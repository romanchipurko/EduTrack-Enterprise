require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  let(:user) { create(:user) }
  let(:learning_path) { create(:learning_path) }
  let(:enrollment) { build(:enrollment, user: user, learning_path: learning_path) }

  describe 'validations' do
    subject { build(:enrollment) }

    it { is_expected.to validate_numericality_of(:progress_percentage).only_integer.is_greater_than_or_equal_to(0).is_less_than_or_equal_to(100) }

    context 'when checking uniqueness of user scoped to learning_path' do
      let(:duplicate_enrollment) { build(:enrollment, user: user, learning_path: learning_path) }

      before do
        create(:enrollment, user: user, learning_path: learning_path)
      end

      it 'is not valid' do
        expect(duplicate_enrollment).not_to be_valid
      end

      it 'adds the correct error message' do
        duplicate_enrollment.valid?
        expect(duplicate_enrollment.errors[:user_id]).to include('has already been taken')
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user).counter_cache(true) }
    it { is_expected.to belong_to(:learning_path).counter_cache(true) }
  end

  describe '#item_completed?' do
    let(:item_id) { BSON::ObjectId.new }

    context 'when the item is in the completed list' do
      before { enrollment.completed_item_ids = [ item_id.to_s ] }

      it 'returns true even if passed a BSON object' do
        expect(enrollment.item_completed?(item_id: item_id)).to be true
      end
    end

    context 'when the item is not in the completed list' do
      it 'returns false' do
        expect(enrollment.item_completed?(item_id: item_id)).to be false
      end
    end
  end

  describe '#complete_item!' do
    let(:item_id) { BSON::ObjectId.new }
    let(:locale) { :en }

    before do
      enrollment.save!
      allow(enrollment.learning_path).to receive(:total_completable_items_count).and_return(4)
      ActiveJob::Base.queue_adapter = :test
    end

    it 'adds the item to completed_item_ids as a string' do
      expect { enrollment.complete_item!(item_id: item_id, locale: locale) }
        .to change(enrollment, :completed_item_ids).from([]).to([ item_id.to_s ])
    end

    it 'calls recalculate_progress! and saves the record' do
      allow(enrollment).to receive(:recalculate_progress!).and_call_original
      enrollment.complete_item!(item_id: item_id, locale: locale)

      expect(enrollment).to have_received(:recalculate_progress!)
    end

    context 'when the item is already completed' do
      before { enrollment.update!(completed_item_ids: [ item_id.to_s ]) }

      it 'does not add the item again' do
        expect { enrollment.complete_item!(item_id: item_id, locale: locale) }
          .not_to change(enrollment, :completed_item_ids)
      end

      it 'does not recalculate progress' do
        allow(enrollment).to receive(:recalculate_progress!)
        enrollment.complete_item!(item_id: item_id, locale: locale)

        expect(enrollment).not_to have_received(:recalculate_progress!)
      end
    end

    context 'when progress reaches 100%' do
      before do
        allow(enrollment.learning_path).to receive_messages(
                                             total_completable_items_count: 1,
                                             valid_completable_item_ids: [ item_id.to_s ]
                                           )
      end

      it 'enqueues CertificateGenerationJob' do
        expect { enrollment.complete_item!(item_id: item_id, locale: locale) }
          .to have_enqueued_job(CertificateGenerationJob)
                .with(user: user, learning_path: learning_path, locale: locale)
      end
    end

    context 'when progress reaches 100% but certificate is already attached' do
      before do
        allow(enrollment.learning_path).to receive_messages(
                                             total_completable_items_count: 1,
                                             valid_completable_item_ids: [ item_id.to_s ]
                                           )
        cert_mock = instance_double(ActiveStorage::Attached::One, attached?: true)
        allow(enrollment).to receive(:certificate).and_return(cert_mock)
      end

      it 'does not enqueue CertificateGenerationJob' do
        expect { enrollment.complete_item!(item_id: item_id, locale: locale) }
          .not_to have_enqueued_job(CertificateGenerationJob)
      end
    end
  end

  describe '#recalculate_progress!' do
    before do
      enrollment.save!
    end

    context 'when the learning path has no completable items' do
      before do
        allow(enrollment.learning_path).to receive_messages(total_completable_items_count: 0, valid_completable_item_ids: [])
      end

      it 'sets the progress_percentage to 0' do
        enrollment.completed_item_ids = [ BSON::ObjectId.new.to_s ]
        enrollment.recalculate_progress!

        expect(enrollment.progress_percentage).to eq(0)
      end
    end

    context 'when the learning path has completable items' do
      let(:valid_item_ids) { Array.new(4) { BSON::ObjectId.new.to_s } }

      before do
        allow(enrollment.learning_path).to receive_messages(total_completable_items_count: 4, valid_completable_item_ids: valid_item_ids)
      end

      it 'calculates 25 percent for 1 out of 4 items' do
        enrollment.completed_item_ids = [ valid_item_ids.first ]
        enrollment.recalculate_progress!

        expect(enrollment.progress_percentage).to eq(25)
      end

      it 'calculates 100 percent for 4 out of 4 items' do
        enrollment.completed_item_ids = valid_item_ids
        enrollment.recalculate_progress!

        expect(enrollment.progress_percentage).to eq(100)
      end

      it 'caps the progress percentage at 100 even if completed items exceed total' do
        enrollment.completed_item_ids = valid_item_ids + [ BSON::ObjectId.new.to_s ]
        enrollment.recalculate_progress!

        expect(enrollment.progress_percentage).to eq(100)
      end
    end
  end
end

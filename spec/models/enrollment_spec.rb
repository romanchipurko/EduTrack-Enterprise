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
    let(:item_id) { BSON::ObjectId.new.to_s }

    context 'when the item is in the completed list' do
      before { enrollment.completed_item_ids = [ item_id ] }

      it 'returns true' do
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
    let(:item_id) { BSON::ObjectId.new.to_s }

    before do
      enrollment.save!
      allow(enrollment.learning_path).to receive(:total_completable_items_count).and_return(4)
    end

    it 'adds the item to completed_item_ids as a string' do
      expect { enrollment.complete_item!(item_id: item_id) }
        .to change(enrollment, :completed_item_ids).from([]).to([ item_id ])
    end

    it 'calls recalculate_progress! and saves the record' do
      allow(enrollment).to receive(:recalculate_progress!).and_call_original
      enrollment.complete_item!(item_id: item_id)

      expect(enrollment).to have_received(:recalculate_progress!)
    end

    context 'when the item is already completed' do
      before { enrollment.update!(completed_item_ids: [ item_id ]) }

      it 'does not add the item again' do
        expect { enrollment.complete_item!(item_id: item_id) }
          .not_to change(enrollment, :completed_item_ids)
      end

      it 'does not recalculate progress' do
        allow(enrollment).to receive(:recalculate_progress!)
        enrollment.complete_item!(item_id: item_id)

        expect(enrollment).not_to have_received(:recalculate_progress!)
      end
    end
  end

  describe '#recalculate_progress!' do
    before do
      enrollment.save!
    end

    context 'when the learning path has no completable items' do
      before do
        allow(enrollment.learning_path).to receive(:total_completable_items_count).and_return(0)
      end

      it 'sets the progress_percentage to 0' do
        enrollment.completed_item_ids = [ BSON::ObjectId.new.to_s ]
        enrollment.recalculate_progress!

        expect(enrollment.progress_percentage).to eq(0)
      end
    end

    context 'when the learning path has completable items' do
      before do
        allow(enrollment.learning_path).to receive(:total_completable_items_count).and_return(4)
      end

      it 'calculates 25 percent for 1 out of 4 items' do
        enrollment.completed_item_ids = [ BSON::ObjectId.new.to_s ]
        enrollment.recalculate_progress!

        expect(enrollment.progress_percentage).to eq(25)
      end

      it 'calculates 100 percent for 4 out of 4 items' do
        enrollment.completed_item_ids = Array.new(4) { BSON::ObjectId.new.to_s }
        enrollment.recalculate_progress!

        expect(enrollment.progress_percentage).to eq(100)
      end

      it 'caps the progress percentage at 100 even if completed items exceed total' do
        enrollment.completed_item_ids = Array.new(5) { BSON::ObjectId.new.to_s }
        enrollment.recalculate_progress!

        expect(enrollment.progress_percentage).to eq(100)
      end
    end
  end
end

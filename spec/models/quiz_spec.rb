require 'rails_helper'

RSpec.describe Quiz, type: :model do
  subject(:quiz) { build(:quiz) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(quiz).to be_valid
    end

    it 'is invalid without a title' do
      quiz.title = nil
      expect(quiz).not_to be_valid
    end
  end

  describe 'associations' do
    it 'embeds many questions' do
      quiz.questions << build(:question)
      expect(quiz.questions.size).to eq(1)
    end
  end

  describe 'callbacks' do
    let(:course_content) { build(:course_content, learning_path_id: '123') }
    let(:quiz) { build(:quiz, course_content: course_content) }

    it 'enqueues RecalculateProgressJob on save' do
      ActiveJob::Base.queue_adapter = :test
      expect { quiz.save! }
        .to have_enqueued_job(RecalculateProgressJob)
              .with(learning_path_id: '123')
    end

    it 'enqueues RecalculateProgressJob on destroy' do
      quiz.save!
      ActiveJob::Base.queue_adapter = :test

      expect { quiz.destroy! }
        .to have_enqueued_job(RecalculateProgressJob)
              .with(learning_path_id: '123')
    end
  end
end

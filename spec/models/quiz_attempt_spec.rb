require 'rails_helper'

RSpec.describe QuizAttempt, type: :model do
  subject(:attempt) { build(:quiz_attempt) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(attempt).to be_valid
    end

    it 'is invalid without a quiz_id' do
      attempt.quiz_id = nil
      expect(attempt).not_to be_valid
    end

    it 'is invalid without a score' do
      attempt.score = nil
      expect(attempt).not_to be_valid
    end

    it 'is invalid with a negative score' do
      attempt.score = -1
      expect(attempt).not_to be_valid
    end
  end

  describe '#percentage' do
    it 'calculates the correct rounded percentage' do
      attempt.score = 2
      attempt.total = 3
      expect(attempt.percentage).to eq(67)
    end

    it 'returns zero when total is zero' do
      attempt.score = 0
      attempt.total = 0
      expect(attempt.percentage).to be_zero
    end
  end

  describe '#quiz' do
    it 'returns nil if the quiz document cannot be found' do
      allow(Quiz).to receive(:find).and_raise(Mongoid::Errors::DocumentNotFound.new(Quiz, {}))
      expect(attempt.quiz).to be_nil
    end
  end
end

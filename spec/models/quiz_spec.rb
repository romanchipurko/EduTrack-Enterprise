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
end

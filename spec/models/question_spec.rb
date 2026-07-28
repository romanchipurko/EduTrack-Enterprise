require 'rails_helper'

RSpec.describe Question, type: :model do
  subject(:question) { build(:question) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(question).to be_valid
    end

    it 'is invalid without text' do
      question.text = nil
      expect(question).not_to be_valid
    end

    it 'is invalid when options array has less than 2 items' do
      question.options = [ 'Only One Option' ]
      expect(question).not_to be_valid
    end

    it 'is invalid without a correct_answer' do
      question.correct_answer = nil
      expect(question).not_to be_valid
    end

    it 'is invalid with a negative correct_answer' do
      question.correct_answer = -1
      expect(question).not_to be_valid
    end
  end
end

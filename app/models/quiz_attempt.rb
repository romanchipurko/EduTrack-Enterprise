class QuizAttempt < ApplicationRecord
  belongs_to :user

  validates :quiz_id, :score, :total, presence: true
  validates :score, numericality: { greater_than_or_equal_to: 0 }

  def quiz
    @quiz ||= Quiz.find(quiz_id)
  rescue Mongoid::Errors::DocumentNotFound
    nil
  end

  def percentage
    return 0 if total.zero?
    (score.to_f / total*100).round
  end
end

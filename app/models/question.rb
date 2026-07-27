class Question
  include Mongoid::Document

  field :text, type: String
  field :options, type: Array, default: []
  field :correct_answer, type: Integer

  embedded_in :quiz, class_name: "::Quiz"

  validates :text, presence: true
  validates :options, presence: true, length: { minimum: 2 }
  validates :correct_answer, presence: true, numericality: { greater_than_or_equal_to: 0 }
end

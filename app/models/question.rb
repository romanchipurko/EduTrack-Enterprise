class Question
  include Mongoid::Document

  field :text, type: String
  field :options, type: Array, default: []
  field :correct_answer, type: Integer

  embedded_in :quiz, class_name: "Quiz"

  before_validation :clean_options

  validates :text, presence: true
  validates :options, presence: true, length: { minimum: 2 }
  validates :correct_answer, presence: true
  validate :correct_answer_range_validation

  private

  def clean_options
    self.options = options.map(&:strip).reject(&:blank?)
  end

  def correct_answer_range_validation
    return if correct_answer.blank?

    errors.add(:correct_answer, I18n.t("quizzes.errors.invalid_range", count: options.size)) if correct_answer < 0 || correct_answer > options.size - 1
  end
end

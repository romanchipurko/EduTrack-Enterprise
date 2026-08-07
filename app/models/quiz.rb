class Quiz
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :course_content, index: true

  field :title, type: String
  embeds_many :questions, class_name: "Question", cascade_callbacks: true, validate: true

  accepts_nested_attributes_for :questions, allow_destroy: true

  validates :title, presence: true

  after_save :trigger_progress_recalculation
  after_destroy :trigger_progress_recalculation

  private

  def trigger_progress_recalculation
    return if (path_id = course_content&.learning_path_id).blank?

    RecalculateProgressJob.perform_later(learning_path_id: path_id)
  end
end

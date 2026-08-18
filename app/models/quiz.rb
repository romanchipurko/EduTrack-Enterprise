class Quiz
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :course_content, index: true

  field :title, type: String
  embeds_many :questions, class_name: "Question", cascade_callbacks: true, validate: true

  accepts_nested_attributes_for :questions, allow_destroy: true

  validates :title, presence: true

  after_save :recalculate_course_enrollments
  after_destroy :recalculate_course_enrollments

  private

  def recalculate_course_enrollments
    return if (path_id = course_content&.learning_path_id).blank?

    Enrollment.where(learning_path_id: path_id).find_each { |enrollment| enrollment.recalculate_progress! }
  end
end

class CourseContent
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :quizzes, dependent: :destroy

  field :learning_path_id, type: String
  field :title, type: String
  field :position, type: Integer
  embeds_many :elements, class_name: "Elements::Base", cascade_callbacks: true

  accepts_nested_attributes_for :elements, allow_destroy: true

  index({ learning_path_id: 1, position: 1 }, unique: true)

  before_validation :set_default_position, if: -> { position.nil? }

  validates :learning_path_id, :title, presence: true
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  after_save :recalculate_enrollments_progress
  after_destroy :recalculate_enrollments_progress

  def learning_path
    return if learning_path_id.blank?

    LearningPath.find_by(id: learning_path_id)
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[title position]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def set_default_position
    return if position.present?

    self.position = self.class.where(learning_path_id: learning_path_id).count + 1
  end

  def recalculate_enrollments_progress
    return if learning_path_id.blank?

    Enrollment.where(learning_path_id: learning_path_id).find_each { |enrollment| enrollment.recalculate_progress! }
  end
end

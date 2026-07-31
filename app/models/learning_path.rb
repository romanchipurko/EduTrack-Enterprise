class LearningPath < ApplicationRecord
  include PgSearch::Model

  has_many :enrollments, dependent: :destroy
  has_many :users, through: :enrollments

  pg_search_scope :search_by_content, against: [ :title, :description ], using: { tsearch: { prefix: true } }

  validates :title, presence: true, format: { with: /\A[\p{L}\p{N}\s\-.&+#]+\z/ }, length: { minimum: 5, maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }

  def course_contents
    CourseContent.includes(:quizzes).where(learning_path_id: self.id).order_by(position: :asc)
  end

  def total_completable_items_count
    contents = course_contents
    quizzes_count = Quiz.where(:course_content_id.in => contents.pluck(:id)).size
    quizzes_count + contents.size
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[title]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end

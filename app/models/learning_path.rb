class LearningPath < ApplicationRecord
  include PgSearch::Model

  pg_search_scope :search_by_content, against: [ :title, :description ], using: { tsearch: { prefix: true } }

  validates :title, presence: true, format: { with: /\A[\p{L}\p{N}\s\-.&+#]+\z/ }, length: { minimum: 5, maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }

  def course_contents
    CourseContent.where(learning_path_id: self.id.to_s).order_by(position: :asc)
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[title]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end

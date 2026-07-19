class LearningPath < ApplicationRecord
  include PgSearch::Model

  TITLE_REGEXP = /\A[\p{L}\p{N}\s\-.&+#]+\z/

  pg_search_scope :search_by_content, against: [ :title, :description ], using: { tsearch: { prefix: true } }

  validates :title, presence: true, format: { with: /\A[\p{L}\p{N}\s\-.&+#]+\z/ }, length: { minimum: 5, maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }
end

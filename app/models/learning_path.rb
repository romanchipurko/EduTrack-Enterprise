class LearningPath < ApplicationRecord
  TITLE_REGEXP = /\A[\p{L}\p{N}\s\-.&+#]+\z/

  validates :title, presence: true, format: { with: TITLE_REGEXP }, length: { minimum: 5, maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }
end

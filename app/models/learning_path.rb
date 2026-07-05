class LearningPath < ApplicationRecord
  validates :title, presence: true, format: { with: /\A[\p{L}\p{N}\s\-.&+#]+\z/ }, length: { minimum: 5, maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }
end

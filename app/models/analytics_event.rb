class AnalyticsEvent < ApplicationRecord
  belongs_to :user
  belongs_to :learning_path

  validates :event_type, presence: true
  validates :lesson_id, presence: true
  validates :payload, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :by_event, ->(type) { where(event_type: type) }
  scope :for_path, ->(path_id) { where(learning_path_id: path_id) }
end

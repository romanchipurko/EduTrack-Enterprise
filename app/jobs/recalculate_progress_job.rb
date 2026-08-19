class RecalculateProgressJob < ApplicationJob
  queue_as :default

  def perform(learning_path_id:)
    return if learning_path_id.blank?

    Enrollment.where(learning_path_id: learning_path_id).find_each do |enrollment|
      enrollment.recalculate_progress!
    end
  end
end

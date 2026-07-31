class Enrollment < ApplicationRecord
  belongs_to :user, counter_cache: true
  belongs_to :learning_path, counter_cache: true

  validates :user_id, uniqueness: { scope: :learning_path_id }
  validates :progress_percentage, presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  def item_completed?(item_id:)
    completed_item_ids.include?(item_id.to_s)
  end

  def complete_item!(item_id:)
    item = item_id.to_s
    return if completed_item_ids.include?(item)

    self.completed_item_ids = (completed_item_ids + [ item ])
    recalculate_progress!
  end

  def recalculate_progress!
    total_items = learning_path.total_completable_items_count

    if total_items.zero?
      self.progress_percentage = 0
    else
      calculated_percentage = ((completed_item_ids.size.to_f / total_items) * 100).round.to_i
      self.progress_percentage = [ calculated_percentage, 100 ].min
    end

    save!
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id user_id learning_path_id progress_percentage created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user learning_path]
  end
end

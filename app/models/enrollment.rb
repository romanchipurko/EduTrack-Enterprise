class Enrollment < ApplicationRecord
  belongs_to :user, counter_cache: true
  belongs_to :learning_path, counter_cache: true

  has_one_attached :certificate

  validates :user_id, uniqueness: { scope: :learning_path_id }
  validates :progress_percentage, presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  def item_completed?(item_id:)
    completed_item_ids.include?(item_id.to_s)
  end

  def complete_item!(item_id:, locale:)
    return if completed_item_ids.include?(item_id.to_s)

    self.completed_item_ids = (completed_item_ids + [ item_id.to_s ])
    recalculate_progress!

    if progress_percentage == 100 && !certificate.attached?
      CertificateGenerationJob.perform_later(user: user, learning_path: learning_path, locale: locale)
    end
  end

  def recalculate_progress!
    total_items = learning_path.total_completable_items_count
    completed_count = completed_actual_count

    self.progress_percentage = total_items.zero? ? 0 : ((completed_count.to_f / total_items) * 100).round.to_i.clamp(0, 100)
    save!
  end

  def completed_actual_count
    return 0 if completed_item_ids.blank?

    valid_ids = learning_path.valid_completable_item_ids
    (completed_item_ids & valid_ids).size
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id user_id learning_path_id progress_percentage created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user learning_path]
  end
end

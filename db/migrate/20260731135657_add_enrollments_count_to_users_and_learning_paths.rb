class AddEnrollmentsCountToUsersAndLearningPaths < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :enrollments_count, :integer, default: 0, null: false
    add_column :learning_paths, :enrollments_count, :integer, default: 0, null: false
  end
end

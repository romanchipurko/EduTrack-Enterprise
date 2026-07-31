class CreateEnrollments < ActiveRecord::Migration[8.0]
  def change
    create_table :enrollments, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :learning_path, null: false, foreign_key: true, type: :uuid
      t.integer :progress_percentage, default: 0, null: false
      t.string :completed_item_ids, array: true, default: [], null: false

      t.timestamps
    end

    add_index :enrollments, [ :user_id, :learning_path_id ], unique: true
  end
end

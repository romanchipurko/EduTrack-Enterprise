class CreateAnalyticsEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :analytics_events, id: :uuid do |t|
      t.string :event_type, null: false
      t.uuid :user_id, null: false
      t.uuid :learning_path_id, null: false
      t.string :lesson_id, null: false
      t.jsonb :payload, null: false, default: {}

      t.timestamps
    end

    add_index :analytics_events, :event_type
    add_index :analytics_events, :user_id
    add_index :analytics_events, :learning_path_id
    add_index :analytics_events, :created_at
  end
end

class CreateQuizAttempts < ActiveRecord::Migration[8.0]
  def change
    create_table :quiz_attempts, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :quiz_id, null: false
      t.integer :score, default: 0
      t.integer :total, default: 0

      t.timestamps
    end
  end
end

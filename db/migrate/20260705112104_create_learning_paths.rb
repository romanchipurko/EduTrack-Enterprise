class CreateLearningPaths < ActiveRecord::Migration[8.0]
  def change
    create_table :learning_paths, id: :uuid do |t|
      t.string :title
      t.text :description

      t.timestamps
    end

    add_index :learning_paths, :title
  end
end

class CreateLearningPaths < ActiveRecord::Migration[8.0]
  def change
    create_table :learning_paths, id: :uuid do |t|
      t.string :title
      t.text :description

      t.check_constraint("title ~ '^[[:alpha:][:digit:][:space:].&+#-]+$'", name: "learning_paths_title_check")

      t.timestamps
    end

    add_index :learning_paths, :title, unique: true
  end
end

class CourseBuilderForm
  include ActiveModel::Model

  attr_accessor :title, :description, :lesson_title

  validates :title, :lesson_title, presence: true

  def save
    return false unless valid?

    LearningPath.transaction do
      @learning_path = LearningPath.new(title: title, description: description)

      unless @learning_path.save
        promote_errors(@learning_path)
        raise ActiveRecord::Rollback
      end

      begin
        create_mongo_documents(path_id: @learning_path.id)
      rescue Mongoid::Errors::Validations => e
        promote_errors(e.document)
        raise ActiveRecord::Rollback
      rescue StandardError => e
        Rails.logger.error("Mongo Save Failed: #{e.message}")
        raise ActiveRecord::Rollback
      end
    end

    @learning_path.persisted?
  end

  def learning_path
    @learning_path
  end

  private

  def create_mongo_documents(path_id:)
    CourseContent.create!(learning_path_id: path_id, title: lesson_title, position: 1)
  end

  def promote_errors(record)
    record.errors.each do |error|
      errors.add(error.attribute, error.message)
    end
  end
end

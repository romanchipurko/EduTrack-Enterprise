class CourseContent
  include Mongoid::Document
  include Mongoid::Timestamps

  field :learning_path_id, type: String
  field :title, type: String
  field :position, type: Integer
  field :elements, type: Array, default: []

  index({ learning_path_id: 1 })
  index({ learning_path_id: 1, position: 1 })
end

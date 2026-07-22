class CourseContent
  include Mongoid::Document
  include Mongoid::Timestamps

  field :learning_path_id, type: String
  field :title, type: String
  field :position, type: Integer
  embeds_many :elements, class_name: "Elements::Base", cascade_callbacks: true

  accepts_nested_attributes_for :elements, allow_destroy: true

  index({ learning_path_id: 1 })
  index({ learning_path_id: 1, position: 1 }, unique: true)

  def self.ransackable_attributes(_auth_object = nil)
    %w[title position]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  validates :learning_path_id, :title, presence: true
  validates :position, presence: true,
                       numericality: { only_integer: true, greater_than_or_equal_to: 0 },
                       uniqueness: { scope: :learning_path_id }
end

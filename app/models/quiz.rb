class Quiz
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :course_content, index: true

  field :title, type: String
  embeds_many :questions, class_name: "Question", cascade_callbacks: true, validate: true

  accepts_nested_attributes_for :questions, allow_destroy: true

  validates :title, presence: true
end

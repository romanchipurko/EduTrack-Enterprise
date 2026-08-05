module Elements
  class Base
    include Mongoid::Document

    ALLOWED_TYPES = %w[
      Elements::Markdown
      Elements::Asset
      Elements::Code
      Elements::Video
    ].freeze

    embedded_in :course_content

    field :_type, type: String
    field :position, type: Integer

    validates :position, presence: true,
                         numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates_uniqueness_of :position
    validates :_type, inclusion: { in: ALLOWED_TYPES }
  end
end

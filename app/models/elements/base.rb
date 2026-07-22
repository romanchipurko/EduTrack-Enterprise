module Elements
  class Base
    include Mongoid::Document

    embedded_in :course_content

    field :position, type: Integer

    validates :position, presence: true,
                         numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates_uniqueness_of :position
  end
end

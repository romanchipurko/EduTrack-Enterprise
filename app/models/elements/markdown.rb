module Elements
  class Markdown < Base
    field :body, type: String
    validates :body, presence: true
  end
end

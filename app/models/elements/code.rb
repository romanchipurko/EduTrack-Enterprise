module Elements
  class Code < Base
    SUPPORTED_LANGUAGES = %w[ruby javascript python html css sql].freeze

    field :language, type: String
    field :content, type: String

    validates :language, :content, presence: true
    validates :language, inclusion: { in: SUPPORTED_LANGUAGES }
  end
end

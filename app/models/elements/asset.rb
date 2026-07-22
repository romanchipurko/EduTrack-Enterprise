module Elements
  class Asset < Base
    field :url, type: String

    validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp }
  end
end

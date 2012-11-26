class Document
  include Mongoid::Document

  field :_id, type: String, default: ->{ URI.parse(uri).normalize.to_s rescue nil }

  field :uri, type: String

  validates :uri, presence: true, uniqueness: true, format: {with: URI::regexp}

  def eligible_for_cache?
    true
  end
end

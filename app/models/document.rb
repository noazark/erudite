class Document
  include Mongoid::Document

  field :_id, type: String, default: ->{ uri.to_s }
  field :uri, type: URIField

  validates :uri, presence: true, uniqueness: true, format: {with: URI::regexp}

  def eligible_for_cache?
    true
  end
end

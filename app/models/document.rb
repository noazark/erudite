class Document
  include Mongoid::Document

  field :_id, type: String, default: ->{ uri.to_s }
  field :uri, type: URIField

  validates :uri, presence: true, uniqueness: true, format: {with: URI::regexp}

  def eligible_for_cache?
    if has_attribute? :cached_at
      return cached_at < 3.days.ago
    else
      return true
    end
  end
end

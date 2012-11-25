class Document
  include Mongoid::Document

  field :_id, type: String, default: ->{ uri }
  field :uri, type: String

  validates :uri, presence: true, uniqueness: true

  def eligible_for_cache?
    true
  end
end

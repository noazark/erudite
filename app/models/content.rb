class Content
  include Mongoid::Document

  field :term, type: String
  field :frequency, type: Integer, default: 0

  embedded_in :document
end

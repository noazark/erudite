class Content
  include Mongoid::Document

  field :term, type: String

  belongs_to :document
end

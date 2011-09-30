class Document
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :title, type: String
  field :uri, type: String
  field :crawled_at, type: DateTime

  has_and_belongs_to_many :links, class_name: "Document", inverse_of: :references
  has_and_belongs_to_many :references, class_name: "Document", inverse_of: :links

  embeds_many :contents

  index :title
  index :uri, unique: true
  index :crawled_at, unique: true

  def self.crawled
    where :title.exists => true
  end
end

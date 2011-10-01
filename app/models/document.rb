class Document
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :title, type: String
  field :uri, type: String
  field :crawled_at, type: DateTime
  field :crawl_duration, type: Integer
  field :links, type: Array
  field :contents, type: Array
  
  field:_cache

  def self.crawled
    where :title.exists => true
  end
end

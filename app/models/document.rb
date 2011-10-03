class Document
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  include Tire::Model::Search
  #include Tire::Model::Callbacks

  field :title, type: String
  field :uri, type: String
  field :crawl_duration, type: Integer
  field :links, type: Array
  field :contents, type: Array

  field:_cache

  field :cached_at, type: DateTime
  field :crawled_at, type: DateTime

  index_name 'mongo-documents'
  mapping do
    indexes :title, :type => 'string', :analyzer => 'snowball', :boost => 100
    indexes :uri, :type => 'string', :analyzer => 'snowball'
  end

  def title
    super || self.uri
  end

  def to_indexed_json
    self.to_json
  end

  def self.crawled
    where :crawled_at.exists => true
  end

  def self.paginate(options = {})
    page(options[:page]).per(options[:per_page])
  end
end


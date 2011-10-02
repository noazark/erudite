require 'open-uri'

class Cache
  @queue = :cache_queue

  def self.perform(document_uri, depth = 1, force = false)
    start_at = Time.now
    if depth <= APP_CONFIG[:crawler][:penetration_depth]
      # Create a document, or find it, based on the passed URI.
      document = Document.find_or_create_by(uri: document_uri)

      # Check and cancel the crawl if the document has been crawled recently
      unless force
        return if document.cached_at && document.cached_at >= Time.now - 6.hours
      end

      # Grab page contents and remove worthless tags
      page = Nokogiri::HTML(open(URI.parse(document.uri)))
      page.xpath("//script").remove
      page.xpath("//style").remove

      document._cache = page.to_s
      document.cached_at = Time.now

      document.save!

      Resque.enqueue(Crawl, document.id, depth)
    end
    p "cached: #{document_uri} - #{Time.now - start_at}"
  end
end


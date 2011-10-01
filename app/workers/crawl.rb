require 'open-uri'

class Crawl
  @queue = :active_crawl_queue

  def self.perform(document_id, depth = 1, force = false)
    start_at = Time.now
    if depth <= 3
      # Create a document, or find it, based on the passed URI.
      document = Document.find(document_id)

      # Check and cancel the crawl if the document has been crawled recently
      #unless force
      #  return if document.crawled_at && document.crawled_at >= Time.now - 6.hours
      #end

      # Grab page contents and remove worthless tags
      page = Nokogiri::HTML(document._cache)

      # Save to document
      #
      # To reduce latency, deffer all possible parsing and interpreting to
      # separate, threaded, workers. All the content is being saved almost
      # exactly as it was found on the page, with a few tricks here and there
      # to break it out into it's pieces

      # Page Title, as found in <head><title>...</title></head>
      document.title = page.xpath("//title").first.content rescue nil

      # Save all the anchors with href values onto the document
      document.links = page.xpath("//a").map do |link|
        link['href'] if link['href'] && !link['href'].empty?
      end

      # Save all the contents (words) found on the page onto the document
      document.contents = page.xpath("//text()").to_s.split

      # Update crawled_at time stamp
      document.crawled_at = DateTime.now
      document.crawl_duration = Time.now - start_at

      # Save and throw error, so the job will fail
      document.save!

      uri = URI.parse(document.uri)

      document.links.each do |link|
        path = URI.parse(link)
        path = uri.merge(path) if path.relative?
        path = URI.escape(path.to_s)
        Resque.enqueue(PassiveCrawl, path, depth.next) if depth < 3
      end
    end
    p "#{document_uri} - #{Time.now - start_at}"
  end
end

require 'open-uri'

class Crawl
  @queue = :active_crawl_queue

  def self.perform(document_id, depth = 1)
    if depth <= 3
    ## Fetch document
      document = Document.find(document_id)

      return if document.crawled_at && document.crawled_at >= Time.now - 6.hours

    ## Grab page contents
      page = Nokogiri::HTML(open(URI.parse document.uri)) 
      page.xpath("//script").remove
      page.xpath("//style").remove
      
      title = page.xpath("//title").first.content rescue nil
      links = page.xpath("//a").map do |link|
        URI.parse(link['href']) if link['href'] && link['href'].match(/^http/)
      end

      contents = page.xpath("//text()").to_s.split

      links.compact.uniq!

    ## Save to document
      document.title = title

      # Create a document for each new link discovered, if the link has already
      # been found, fetch it instead. This reference will be added to our
      # current document's links array.
      #
      # Once finished, the child will be added to the Passive Crawl Queue, this
      # queue is designed for all lower level crawls that should take precedence
      # below the higher level, Active Crawl Queue.
      links.each do |link|
        child = Document.find_or_create_by(uri: link)
        document.links.push(child)
        Resque.enqueue(PassiveCrawl, child.id, depth.next) if depth < 3
      end

      # Clearing document contents to make room for new list
      document.contents.delete_all

      # Loop through all unique terms found on the page
      # and add them to the document's content array
      contents.uniq.each do |term|
        document.contents.create(term: term, frequency: contents.grep(term).size)
      end

      # Update crawled_at time stamp
      document.crawled_at = DateTime.now

      # Save and throw error, so the job will fail
      document.save!
    end
  end
end

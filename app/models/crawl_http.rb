class CrawlHTTP

  class MaxDepthError < Exception
  end

  def self.perform(uri, depth=1)
    crawl_document(uri, depth)
  end

  def self.links(page)
    page.xpath("//a").map do |link|
      link['href'] if link['href']
    end.compact.delete_if &:empty?
  end

  def self.normalize_link(path, uri)
    URI.join(uri, URI.escape(path))
      .to_s
  end

private

  def self.crawl_document(uri, depth)
    document = Document.find uri

    page = Nokogiri::HTML(document.body)

    links(page).each do |link|
      normalized_link = normalize_link link, uri
      unless depth >= 3
        Resque.enqueue(Cache, normalized_link, depth.next)
      else
        raise MaxDepthError.new, "You have reached the end of the rainbow."
      end
    end

    document[:crawled_at] = Time.now
    document.save

    document
  end

end
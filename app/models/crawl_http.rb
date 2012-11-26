class CrawlHTTP

  def self.perform(uri)
    crawl_document(uri)
  end

  def self.links(page)
    page.xpath("//a").map do |link|
      link['href'] if link['href']
    end.compact.delete_if &:empty?
  end

  def self.normalize_path(path, uri)
    URI.join(uri, URI.escape(path))
      .normalize
      .to_s
  end

private

  def self.crawl_document(uri)
    document = Document.find_by uri: uri

    page = Nokogiri::HTML(document.body)

    document[:crawled_at] = Time.now
    document.save

    links(page).map do |link|
      normalize_path link, uri
    end
  end

end
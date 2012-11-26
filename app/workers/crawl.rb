class Crawl
  @queue = :crawl_queue

  def self.perform(uri, depth = 1)
    links = CrawlHTTP.perform uri

    links.each do |link|
      Resque.enqueue(Cache, link, depth.next)
    end
  end
end

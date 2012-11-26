class Cache
  @queue = :cache_queue

  def self.perform(uri, depth = 1)
    CacheHTTP.perform uri
    Resque.enqueue(Crawl, uri, depth) unless depth >= 3
  end
end

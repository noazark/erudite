require 'open-uri'

class PassiveCrawl < Crawl
  @queue = :passive_crawl_queue
end

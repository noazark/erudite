require 'open-uri'

class Cache
  @queue = :cache_queue

  def self.perform(document_id, force = false)
    document = Document.find(document_id)
    document.links.each do |link|
      reference = Document.first(conditions: { uri: link })
      Document.references << reference
    end
  end
end


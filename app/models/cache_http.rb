require 'net/http'

class CacheHTTP

  def self.perform(uri)
    cache_document(uri)
  end

private

  def self.fetch(uri)
    Net::HTTP.get_response URI.parse(uri)
  end

  def self.cache_document(uri)
    document = Document.find_or_initialize_by uri: uri
    document = document.becomes HTTPDocument

    if document.eligible_for_cache?
      response = fetch(uri)

      document.update_attributes headers: response.to_hash,
        body: response.body
    end

    document[:cached_at] = Time.now
    document.save

    document
  end

end
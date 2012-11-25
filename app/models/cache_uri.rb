require 'net/http'

class CacheURI

  def self.perform(uri)
    cache_document(uri)
  end

private

  def self.fetch(uri)
    Net::HTTP.get_response URI.parse(uri)
  end

  def self.cache_document(uri)
    document = Document.find_or_initialize_by uri: uri

    response = fetch(uri)
    
    document.update_attributes uri: uri, body: response.body
    document
  end

end
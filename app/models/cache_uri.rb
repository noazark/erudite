require 'net/http'

class CacheURI

  def self.perform(uri)
    url = URI.parse(uri)
    response = Net::HTTP.get_response(url)
    Document.create uri: uri, body: response.body
  end

end
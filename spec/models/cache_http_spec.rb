require "spec_helper"

describe CacheHTTP do

  let(:uri) do
    "http://example.com"
  end

  let(:response_headers) do
    {
      "x-idk" => ["..."]
    }
  end

  let(:response_body) do
    "hello world"
  end

  before do
    stub_request(:get, uri).to_return(
      :headers => response_headers,
      :body => response_body
    )
  end

  it "creates a cached document" do
    CacheHTTP.perform(uri)
    Document.find(uri).should_not be_nil
  end

  it "updates an already cached document" do
    original = HTTPDocument.create! uri: uri, body: 'foo bar'
    cached = CacheHTTP.perform(uri)

    original.reload
    cached.should eq original
  end
  
  it "sets the document headers" do
    CacheHTTP.perform(uri).headers.should eq response_headers
  end
  
  it "sets the document body" do
    CacheHTTP.perform(uri).body.should eq response_body
  end
  
  it "returns the cached http document" do
    CacheHTTP.perform(uri).should be_a HTTPDocument
  end

end
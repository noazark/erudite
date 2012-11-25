require "spec_helper"

describe CacheURI do

  let(:uri) do
    "http://example.com"
  end

  let(:response_body) do
    "hello world"
  end

  before do
    stub_request(:get, uri).to_return(:body => response_body)
  end

  it "creates a cached document from the response" do
    CacheURI.perform(uri)
    Document.find(uri).should_not be_nil
  end

  it "updates an already cached document" do
    original = Document.create! uri: uri, body: 'foo bar'
    cached = CacheURI.perform(uri)

    original.reload
    cached.should eql original
  end
  
  it "makes an http request to the uri" do
    CacheURI.perform(uri).body.should eq response_body
  end
  
  it "returns the cached document" do
    CacheURI.perform(uri).should be_a Document
  end

end
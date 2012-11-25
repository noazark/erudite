require "spec_helper"

describe CacheURI do

  let(:uri) do
    "http://example.com"
  end

  before do
    stub_request(:get, uri).to_return(:body => "hello world")
  end

  it "creates a cached document from the response" do
    CacheURI.perform(uri)
    Document.find(uri).should_not be_nil
  end
  
  it "makes an http request to the uri" do
    stub_request(:get, uri).to_return(:body => "hello world")
    CacheURI.perform(uri).body.should eq "hello world"
  end

end
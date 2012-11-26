require "spec_helper"

describe CrawlHTTP do

  let(:uri) do
    'http://example.com'
  end

  let(:html) do
    "<a href=\"http://example.com\"></a>"
  end

  let(:empty_href) do
    "<a href=\"\"></a>"
  end

  let(:empty_anchor) do
    "<a></a>"
  end

  let!(:cached_document) do
    Document.create uri: uri, body: html
  end

  before do
    Timecop.freeze

    Resque.queues.each do |queue|
      Resque.remove_queue(queue)
    end
  end

  after do
    Timecop.return
  end

  it "updates the crawl timestamp" do
    CrawlHTTP.perform(uri).crawled_at.should eq Time.now
  end
  
  it "finds all the links on a page" do
    page = Nokogiri::HTML(html)
    CrawlHTTP.links(page).length.should eq 1
  end

  it "ignores all the empty links" do
    page = Nokogiri::HTML(html + empty_href)
    CrawlHTTP.links(page).length.should eq 1
  end

  it "ignores all the anchors without href attributes" do
    page = Nokogiri::HTML(html + empty_anchor)
    CrawlHTTP.links(page).length.should eq 1
  end

  it "converts link URIs from relative to absolute" do
    CrawlHTTP.normalize_link('/test', 'http://example.com/page')
      .should eq 'http://example.com/test'
  end

  it "escapes links for primetime" do
    CrawlHTTP.normalize_link('http://ahh.com/search?q=Show me the money', 'http://example.com/page')
      .should eq 'http://ahh.com/search?q=Show%20me%20the%20money'
  end

  it "spawns cache workers for each link found" do
    CrawlHTTP.perform(uri)
    Resque.size(:cache_queue).should eq 1
  end

  it "increments depth of spawns" do
    Document.create uri: 'http://example.com/another', body: '<a href="/sup"></a>'
    CrawlHTTP.perform('http://example.com/another')
    Resque.pop(:cache_queue)['args'][0].should eq 'http://example.com/sup'
  end

  it "normalizes uri for spawn" do
    CrawlHTTP.perform(uri, 2)
    Resque.pop(:cache_queue)['args'][1].should eq 3
  end

  it "raises an error if the maximum depth has been reached" do
    expect do
      CrawlHTTP.perform(uri, 3)
    end.to raise_error CrawlHTTP::MaxDepthError
  end

end
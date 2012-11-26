require "spec_helper"

describe CrawlHTTP do

  let(:uri) do
    'http://example.com/'
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
    Timecop.freeze Time.local(2012)

    Resque.queues.each do |queue|
      Resque.remove_queue(queue)
    end
  end

  after do
    Timecop.return
  end

  it "updates the crawl timestamp" do
    CrawlHTTP.perform(uri)
    cached_document.reload
    cached_document.crawled_at.should eq Time.now
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
    CrawlHTTP.normalize_path('', 'http://example.com')
      .should eq 'http://example.com/'
  end

  it "normalizes links" do
    CrawlHTTP.normalize_path('/test', 'http://example.com/page')
      .should eq 'http://example.com/test'
  end

  it "escapes links for primetime" do
    CrawlHTTP.normalize_path('http://ahh.com/search?q=Show me the money', 'http://example.com/page')
      .should eq 'http://ahh.com/search?q=Show%20me%20the%20money'
  end

  it "normalizes each uri" do
    Document.create uri: 'http://example.com/another', body: '<a href="/sup"></a>'
    CrawlHTTP.perform('http://example.com/another').pop.should eq 'http://example.com/sup'
  end

end
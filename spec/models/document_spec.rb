require 'spec_helper'

describe Document do

  it "overrides the default id" do
    uri = 'http://example.com/'
    subject = Document.new uri: uri
    subject.id.should eq uri
  end

  it "normalizes the id" do
    uri = 'http://EXAMPLE.com'
    subject = Document.new uri: uri
    subject.id.should eq 'http://example.com/'
  end

  it "generates a URI safe slug" do
    uri = 'http://example.com'
    subject = Document.new uri: uri
    subject.slug.should eq Digest::SHA1.hexdigest 'http://example.com/'
  end

  it "requires a uri" do
    should validate_presence_of :uri
  end

  it "requires a unique uri" do
    should validate_uniqueness_of :uri
  end

  it "requires a valid uri" do
    Document.new(uri: 'what is this?').should_not be_valid
  end
  
  describe "#eligible_for_cache?" do

    it "true when the document has never been cached" do
      subject.delete(:cached_at)
      subject.eligible_for_cache?.should be_true
    end
    
    it "true when the document should be cached" do
      subject[:cached_at] = 4.days.ago
      subject.eligible_for_cache?.should be_true
    end
    
    it "false when the document should not be cached" do
      subject[:cached_at] = Time.now
      subject.eligible_for_cache?.should be_false
    end

  end

end

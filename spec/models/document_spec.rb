require 'spec_helper'

describe Document do

  it "overrides the default id" do
    uri = 'http://example.com'
    subject = Document.new uri: uri
    subject.id.should eq uri
  end

  it "requires a uri" do
    should validate_presence_of :uri
  end

  it "requires a unique uri" do
    should validate_uniqueness_of :uri
  end

  it "is always eligible for cache" do
    subject.eligible_for_cache?.should be_true
  end

end

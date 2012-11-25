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

  describe "cache" do
    
    it "gets the contents at the URI"

  end

end

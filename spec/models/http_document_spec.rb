require "spec_helper"

describe HTTPDocument do
  
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
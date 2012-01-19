require 'spec_helper'

describe "Matcher" do
  before do
    @matcher = DUI::Matcher.new
  end

  describe "when given no data" do
    before do
      @result = @matcher.match [], []
    end
  
    it "blah" do
      @result.empty?.must_equal true  
    end
    
  end
end

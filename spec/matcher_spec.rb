require 'spec_helper'

describe "Matcher" do
  before do
    @matcher = DUI::Matcher.new
  end

  describe "when there is no existing data" do
    before do
      @matcher.current_data = []
    end
  
    describe "and it is given no data" do
      before do
        @matcher.new_data = []
      end

      it "should have no records to delete" do
        assert_equal 0, @matcher.records_to_delete.count
      end

      it "should have no records to update" do
        assert_equal 0, @matcher.records_to_update.count
      end

      it "should have no records to insert" do
        assert_equal 0, @matcher.records_to_insert.count
      end
    end
    
  end
end

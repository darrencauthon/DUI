require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

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

    describe "and it is given one new record" do
      before do
        @matcher.new_data = [TestProduct.new(1)]
      end
    
      it "should have one records to insert" do
        assert_equal 1, @matcher.records_to_insert.count
      end

      it "should return the record in the new data" do
        @matcher.new_data.each do |x|
          assert_equal true, @matcher.records_to_insert.include?(x)
        end
      end
    end
    
  end

  class TestProduct

    attr_accessor :id

    def initialize(id)
      @id = id
    end

  end
end

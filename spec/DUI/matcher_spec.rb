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
    
      it "should have no records to delete" do
        assert_equal 0, @matcher.records_to_delete.count
      end

      it "should have no records to update" do
        assert_equal 0, @matcher.records_to_update.count
      end

      it "should have one records to insert" do
        assert_equal 1, @matcher.records_to_insert.count
      end

      it "should return the new record as a record to insert" do
        @matcher.new_data.each do |x|
          assert_equal true, @matcher.records_to_insert.include?(x)
        end
      end
    end
    
  end

  describe "when there is one existing record" do
    before do
      @matcher.current_data = [TestProduct.new(3)]
    end
  
    describe "and it is given no new data" do
      before do
        @matcher.new_data = []
      end

      it "should have one records to delete" do
        assert_equal 1, @matcher.records_to_delete.count
      end

      it "should return the current record as a record to delete" do
        @matcher.current_data.each do |x|
          assert_equal true, @matcher.records_to_delete.include?(x)
        end
      end

      it "should have no records to update" do
        assert_equal 0, @matcher.records_to_update.count
      end

      it "should have no records to insert" do
        assert_equal 0, @matcher.records_to_insert.count
      end
    end

    describe "and it is given the same record" do
      before do
        @matcher.new_data = [TestProduct.new(3)]
      end
    
      it "should have no records to delete" do
        assert_equal 0, @matcher.records_to_delete.count
      end

      it "should have one records to update" do
        assert_equal 1, @matcher.records_to_update.count
      end

      it "should return the existing record as a record to update" do
        assert_equal 1, @matcher.records_to_update.select{|x| x.id == 3}.count
      end

      it "should have no records to insert" do
        assert_equal 0, @matcher.records_to_insert.count
      end
    end

    describe "and it is given a different record" do
      before do
        @matcher.new_data = [TestProduct.new(5)]
      end
    
      it "should have no records to delete" do
        assert_equal 1, @matcher.records_to_delete.count
      end

      it "should return the existing record as a record to delete" do
        assert_equal 1, @matcher.records_to_delete.select{|x| x.id == 3}.count
      end

      it "should have no records to update" do
        assert_equal 0, @matcher.records_to_update.count
      end

      it "should have one record to insert" do
        assert_equal 1, @matcher.records_to_insert.count
      end

      it "should return the new record as a record to insert" do
        assert_equal 1, @matcher.records_to_insert.select{|x| x.id == 5}.count
      end
    end

    describe "and it is given the existing record and the same record" do
      before do
        @matcher.new_data = [TestProduct.new(3), TestProduct.new(5)]
      end
    
      it "should have no records to delete" do
        assert_equal 0, @matcher.records_to_delete.count
      end

      it "should have one records to update" do
        assert_equal 1, @matcher.records_to_update.count
      end

      it "should return the existing record as a record to update" do
        assert_equal 1, @matcher.records_to_update.select{|x| x.id == 3}.count
      end

      it "should have one records to insert" do
        assert_equal 1, @matcher.records_to_insert.count
      end

      it "should return the new records as a record to insert" do
        assert_equal 1, @matcher.records_to_insert.select{|x| x.id == 5}.count  
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

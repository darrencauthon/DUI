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
        @results = @matcher.execute
      end

      it "should have no records to delete" do
        assert_equal 0, @results.records_to_delete.count
      end

      it "should have no records to update" do
        assert_equal 0, @results.records_to_update.count
      end

      it "should have no records to insert" do
        assert_equal 0, @results.records_to_insert.count
      end
    end

    describe "and it is given one new record" do
      before do
        @matcher.new_data = [new_record_with_id(1)]
        @results = @matcher.execute
      end
    
      it "should have no records to delete" do
        assert_equal 0, @results.records_to_delete.count
      end

      it "should have no records to update" do
        assert_equal 0, @results.records_to_update.count
      end

      it "should have one records to insert" do
        assert_equal 1, @results.records_to_insert.count
      end

      it "should return the new record as a record to insert" do
        @matcher.new_data.each do |x|
          assert_equal true, @results.records_to_insert.include?(x)
        end
      end
    end
  end

  describe "when there is one existing record" do
    before do
      @matcher.current_data = [new_record_with_id(3)]
    end
  
    describe "and it is given no new data" do
      before do
        @matcher.new_data = []
        @results = @matcher.execute
      end

      it "should have one records to delete" do
        assert_equal 1, @results.records_to_delete.count
      end

      it "should return the current record as a record to delete" do
        @matcher.current_data.each do |x|
          assert_equal true, @results.records_to_delete.include?(x)
        end
      end

      it "should have no records to update" do
        assert_equal 0, @results.records_to_update.count
      end

      it "should have no records to insert" do
        assert_equal 0, @results.records_to_insert.count
      end
    end

    describe "and it is given the same record" do
      before do
        @matcher.new_data = [new_record_with_id(3)]
        @results = @matcher.execute
      end
    
      it "should have no records to delete" do
        assert_equal 0, @results.records_to_delete.count
      end

      it "should have one records to update" do
        assert_equal 1, @results.records_to_update.count
      end

      it "should return the existing record as a record to update" do
        assert_equal 1, @results.records_to_update.select{|x| x.id == 3}.count
      end

      it "should have no records to insert" do
        assert_equal 0, @results.records_to_insert.count
      end
    end

    describe "and it is given a different record" do
      before do
        @matcher.new_data = [new_record_with_id(5)]
        @results = @matcher.execute
      end
    
      it "should have no records to delete" do
        assert_equal 1, @results.records_to_delete.count
      end

      it "should return the existing record as a record to delete" do
        assert_equal 1, @results.records_to_delete.select{|x| x.id == 3}.count
      end

      it "should have no records to update" do
        assert_equal 0, @results.records_to_update.count
      end

      it "should have one record to insert" do
        assert_equal 1, @results.records_to_insert.count
      end

      it "should return the new record as a record to insert" do
        assert_equal 1, @results.records_to_insert.select{|x| x.id == 5}.count
      end
    end

    describe "and it is given the existing record and the same record" do
      before do
        @matcher.new_data = [new_record_with_id(3), new_record_with_id(5)]
        @results = @matcher.execute
      end
    
      it "should have no records to delete" do
        assert_equal 0, @results.records_to_delete.count
      end

      it "should have one records to update" do
        assert_equal 1, @results.records_to_update.count
      end

      it "should return the existing record as a record to update" do
        assert_equal 1, @results.records_to_update.select{|x| x.id == 3}.count
      end

      it "should have one records to insert" do
        assert_equal 1, @results.records_to_insert.count
      end

      it "should return the new records as a record to insert" do
        assert_equal 1, @results.records_to_insert.select{|x| x.id == 5}.count  
      end
    end

    describe "when there are two existing records" do
      before do
        @matcher.current_data = [new_record_with_id(7), new_record_with_id(8)]
      end
    
      describe "and no new data is passed" do
        before do
          @matcher.new_data = []
          @results = @matcher.execute
        end

        it "should return 2 records to delete" do
          assert_equal 2, @results.records_to_delete.count
        end

        it "should return 0 records to update" do
          assert_equal 0, @results.records_to_update.count
        end

        it "should return 0 records to insert" do
            assert_equal 0, @results.records_to_insert.count
        end
      end

      describe "and both existing records are passed" do
        before do
          @matcher.new_data = [new_record_with_id(8), new_record_with_id(7)]
          @results = @matcher.execute
        end

        it "should return 0 records to delete" do
          assert_equal 0, @results.records_to_delete.count  
        end

        it "should return 2 records to update" do
            assert_equal 2, @results.records_to_update.count 
        end

        it "should return both records as ready for update" do
          assert_equal 1, @results.records_to_update.select{|x|x.id == 8}.count  
          assert_equal 1, @results.records_to_update.select{|x|x.id == 7}.count  
        end

        it "should return no records for insertion" do
          assert_equal 0, @results.records_to_insert.count  
        end
      end

    end
  end

  def new_record_with_id(id)
    Hashie::Mash.new :id => id
  end

end

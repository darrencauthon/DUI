module DUI

  class Matcher
    attr_accessor :current_data, :new_data

    def execute
      MatcherResult.new(:records_to_delete => get_records_to_delete, 
                        :records_to_update => get_records_to_update,
                        :records_to_insert => get_records_to_insert)
    end

    private 

    def get_records_to_insert
      records = []
      @new_data.each do |n|
        records << n unless @current_data.select{|c| c.id == n.id}.count == 1
      end
      records
    end

    def get_records_to_delete
      records = []
      @current_data.each do |c|
        records << c unless @new_data.select{|n| c.id == n.id}.count == 1
      end
      records
    end

    def get_records_to_update
      records = []
      @current_data.each do |c|
        records << c if @new_data.select{|n| c.id == n.id}.count == 1
      end
      records
    end
  end
end

module DUI

  class Matcher
    attr_accessor :current_data, :new_data

    def records_to_delete
      @current_data.each do |c|
        return [] if @new_data.select{|n| c.id == n.id}.count == 1
      end
      return @current_data if @new_data 
      []
    end

    def records_to_update
      @current_data.each do |c|
        return [c] if @new_data.select{|n| c.id == n.id}.count == 1
      end
      []
    end

    def records_to_insert
      records = []
      @new_data.each do |n|
        records << n unless @current_data.select{|c| c.id == n.id}.count == 1
      end
      records
    end
  end
end

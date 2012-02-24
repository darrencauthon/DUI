module DUI

  class Matcher

    def initialize(&compare_method)
      @compare_method = compare_method || Proc.new {|c, n| c.id == n.id }
    end

    def execute(current_data, new_data)
      @current_data = current_data
      @new_data = new_data
      Hashie::Mash.new(:records_to_delete => get_records_to_delete, 
                       :records_to_update => get_records_to_update,
                       :records_to_insert => get_records_to_insert)
    end

    private 

    def get_records_to_insert
      return @new_data.select {|n| @current_data.select {|c| @compare_method.call(c, n) }.count == 0 }
    end

    def get_records_to_delete
      return @current_data.select {|c| @new_data.select {|n| @compare_method.call(c, n) }.count == 0 }
    end

    def get_records_to_update
      @current_data.select {|c| @new_data.select {|n| @compare_method.call(c, n) }.count == 1}
    end
  end
end

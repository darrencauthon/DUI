module DUI

  class Matcher

    def initialize(&compare_method)
      @compare_method = compare_method || Proc.new {|c, n| c.id == n.id }
    end

    def execute(current_data, new_data)
      Hashie::Mash.new(:records_to_delete => records_to_delete(current_data, new_data), 
                       :records_to_update => records_to_update(current_data, new_data),
                       :records_to_insert => records_to_insert(current_data, new_data))
    end

    def records_to_insert(current_data, new_data)
      return new_data.select {|n| current_data.select {|c| @compare_method.call(c, n) }.count == 0 }
    end

    def records_to_delete(current_data, new_data)
      return current_data.select {|c| new_data.select {|n| @compare_method.call(c, n) }.count == 0 }
    end

    def records_to_update(current_data, new_data)
      current_data.select {|c| new_data.select {|n| @compare_method.call(c, n) }.count == 1}
    end
  end
end

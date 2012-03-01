module DUI

  class Matcher

    def initialize(&compare_method)
      @compare_method = compare_method || Proc.new {|c, n| c.id == n.id }
    end

    def get_results(current_data, new_data)
      Hashie::Mash.new(:records_to_delete => get_records_to_delete(current_data, new_data), 
                       :records_to_update => get_records_to_update(current_data, new_data),
                       :records_to_insert => get_records_to_insert(current_data, new_data))
    end

    def get_records_to_insert(current_data, new_data)
      return new_data.select {|n| current_data.select {|c| @compare_method.call(c, n) }.count == 0 }
    end

    def get_records_to_delete(current_data, new_data)
      return current_data.select {|c| new_data.select {|n| @compare_method.call(c, n) }.count == 0 }
    end

    def get_records_to_update(current_data, new_data)
      updates = current_data.select {|c| new_data.select {|n| @compare_method.call(c, n) }.count == 1}
      updates.map do |c|
        mash = Hashie::Mash.new
        mash.current = c
        mash.new = new_data.select{|n| @compare_method.call(c, n)}.first
        mash
      end
    end
  end
end

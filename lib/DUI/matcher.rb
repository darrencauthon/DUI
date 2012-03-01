module DUI

  class Matcher

    def initialize(&compare_method)
      @compare_method = compare_method || Proc.new {|c, n| c.id == n.id }
    end

    def get_results(current_data, new_data)
      records_to_delete = []
      records_to_update = []
      current_data.each do |c| 
        a_match_in_the_new_data = new_data.select {|n| @compare_method.call(c, n) }.first
        if !a_match_in_the_new_data.nil?
          records_to_update << Hashie::Mash.new({:current => c, :new => a_match_in_the_new_data})
        else
          records_to_delete << c
        end
      end
      Hashie::Mash.new(:records_to_delete => records_to_delete, 
                       :records_to_update => records_to_update,
                       :records_to_insert => get_records_to_insert(records_to_update.map{|u| u.current}, new_data))
    end

    def get_records_to_insert(current_data, new_data)
      new_data.select {|n| current_data.select {|c| @compare_method.call(c, n) }.count == 0 }
    end
  end
end

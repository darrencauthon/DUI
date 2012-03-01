module DUI

  class Matcher

    def initialize(&compare_method)
      @compare_method = compare_method || Proc.new {|c, n| c.id == n.id }
    end

    def get_results(current_data, new_data)
      results = Hashie::Mash.new(:records_to_delete => [], :records_to_update => [])
      all_current_data_with_matches_in_new_data(current_data, new_data).each do |match| 
        if match.no_match_found_in_new_data
          results.records_to_delete << match.current
        else
          results.records_to_update << match 
        end
      end
      results.records_to_insert = get_records_to_insert(results.records_to_update.map{|u| u.current}, new_data)
      results
    end

    def all_current_data_with_matches_in_new_data(current_data, new_data)
      current_data.map do |c| 
        match = Hashie::Mash.new({:current => c})
        match.new = new_data.select {|n| @compare_method.call(c, n) }.first
        match.no_match_found_in_new_data = match.nil?
        match
      end
    end

    def get_records_to_insert(current_data, new_data)
      new_data.select {|n| current_data.select {|c| @compare_method.call(c, n) }.count == 0 }
    end
  end
end

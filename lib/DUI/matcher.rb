module DUI

  class Matcher

    def initialize(&compare_method)
      @compare_method = compare_method || Proc.new { |c, n| c.id == n.id }
    end

    def get_results(current_data, new_data)
      results = get_the_results_of_the_delete_and_update_process(current_data, new_data) 
      results.records_to_insert = get_records_to_insert(results, new_data)
      results
    end

    private 

    def get_the_results_of_the_delete_and_update_process(current_data, new_data)
      results = an_object_with(:records_to_delete => [], :records_to_update => [])
      all_current_data_with_possible_matches_in_new_data(current_data, new_data).each do |match| 
        if match.current_not_found_in_new
          results.records_to_delete << match.current
        else
          results.records_to_update << match 
        end
      end
      results
    end

    def all_current_data_with_possible_matches_in_new_data(current_data, new_data)
      current_data.map do |c| 
        an_object_with( {:current => c} ) do |result|
          result.new = new_data.select { |n| @compare_method.call(c, n) }.first
          result.current_not_found_in_new = result.new.nil?
        end
      end
    end

    def get_records_to_insert(results, new_data)
      current_records = results.records_to_update.map{|u| u.current}
      new_data.select { |n| current_records.select { |c| @compare_method.call(c, n) }.count == 0 }
    end

    def an_object_with(hash)
      the_object = Hashie::Mash.new(hash)
      yield the_object if block_given?
      the_object
    end
  end
end

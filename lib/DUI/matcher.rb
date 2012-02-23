module DUI

  class Matcher
    attr_accessor :current_data, :new_data

    def execute
      Hashie::Mash.new(:records_to_delete => get_records_to_delete, 
                       :records_to_update => get_records_to_update,
                       :records_to_insert => get_records_to_insert)
    end

    private 

    def get_records_to_insert
      return @new_data.select{|n| @current_data.select{|c| c.id == n.id}.count == 0 }
    end

    def get_records_to_delete
      return @current_data.select{|c| @new_data.select{|n| c.id == n.id}.count == 0 }
    end

    def get_records_to_update
      @current_data.select{|c| @new_data.select{|n| c.id == n.id}.count == 1}
    end
  end
end

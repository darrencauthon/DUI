module DUI

  class Matcher
    attr_accessor :current_data, :new_data

    def records_to_delete
      []
    end

    def records_to_update
      []
    end

    def records_to_insert
      []
    end
  end
end

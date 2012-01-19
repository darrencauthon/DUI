module DUI

  class Matcher
    def method_missing(meth, *args, &blk)
      []
    end
  end
end

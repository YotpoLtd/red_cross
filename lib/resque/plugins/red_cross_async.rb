module Resque
  module Plugins
    module RedCrossAsync
      def after_perform_flush(*args)
        RedCross.flush
      end
    end
  end
end

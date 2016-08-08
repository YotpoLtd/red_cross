module RedCross
  module Trackers
    class Base
      def track(attrs, additional_args = {})
        raise NotImplementedError
      end

      def identify(attrs, additional_args = {})
        raise NotImplementedError
      end

      def flush
        raise NotImplementedError
      end
    end
  end
end

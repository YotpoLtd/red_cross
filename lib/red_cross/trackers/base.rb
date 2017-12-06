module RedCross
  module Trackers
    class Base
      include RedCross::Logging

      def track(attrs, additional_args = {})
        raise NotImplementedError
      end

      def identify(attrs, additional_args = {})
        raise NotImplementedError
      end

      def flush
        raise NotImplementedError
      end

      def group(attrs, additional_args = {})
        raise NotImplementedError
      end
    end
  end
end

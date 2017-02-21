module RedCross
  module Trackers
    class Base

      def self.inherited(tracker)
        RedCross::Configuration.add_trackers_type(type, tracker)
      end

      def self.type
        :base
      end

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

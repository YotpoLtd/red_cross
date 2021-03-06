module RedCross
  module Trackers
    class SegmentTracker < RedCross::Trackers::Base
      attr_accessor :segment_write_key, :client

      def initialize(segment_write_key)
        @client = Segment::Analytics.new({write_key:  segment_write_key})
      end

      def track(attrs, additional_args = {})
        @client.track(attrs)
      end

      def identify(attrs, additional_args = {})
        @client.identify(attrs)
      end

      def flush
        @client.flush
      end

      def group(attrs, additional_args = {})
        @client.group(attrs)
      end
    end
  end
end

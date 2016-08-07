module RedCross
  module Configuration
    class << self
      attr_accessor :path, :segment_write_key, :segment, :influxdb_connect

      def configure
        yield self
        init_segment
      end

      private

      def init_segment
        @segment = Segment::Analytics.new({write_key: segment_write_key})
      end

    end
  end
end
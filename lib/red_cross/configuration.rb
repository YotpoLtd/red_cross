module RedCross
  module Configuration
    class << self
      attr_accessor :path, :segment_write_key, :segment, :influxdb_connect, :influxdb

      def configure
        yield self
        init_segment
        init_influxdb
      end

      private

      def init_segment
        @segment = Segment::Analytics.new({write_key:  segment_write_key})
      end

      def init_influxdb
        return unless influxdb_connect[:database].present?
        return unless influxdb_connect[:host].present?
        return unless influxdb_connect[:port].present?
        @influxdb = InfluxDB::Client.new influxdb_connect[:database],
                                         host:  influxdb_connect[:host],
                                         port:  influxdb_connect[:port],
                                         async: true
      end


    end
  end
end
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
        return unless influxdb_connect
        InfluxDB::Rails.configure do |config|
          config.influxdb_database = influxdb_connect[:database] || 'red_cross_db'
          config.influxdb_hosts    = [(influxdb_connect[:host] || 'localhost')]
          config.influxdb_port     = influxdb_connect[:port] || '8086'
          config.series_name_for_controller_runtimes = "controller"
          config.series_name_for_view_runtimes       = "view"
          config.series_name_for_db_runtimes         = "db"
        end
        @influxdb = InfluxDB::Rails.client
        InfluxDB::Rails.client.stop!
      end

    end
  end
end
module RedCross
  module Configuration
    class << self
      attr_accessor :path, :segment_write_key, :segment, :influxdb_creds, :influxdb

      def configure
        yield self
        init_segment
        init_influxdb
      end

      private

      def init_segment
        @segment = Segment::Analytics.new({write_key: (ENV['SEGMENT_WRITE_KEY'] || segment_write_key)})
      end

      def init_influxdb
        @influxdb = InfluxDB::Rails.configure do |config|
          config.influxdb_database = "yotpo_api_" + Rails.env
          config.influxdb_hosts    = [ENV['INFLUXDB_HOST']]
          config.influxdb_port     = ENV['INFLUXDB_PORT']

          config.series_name_for_controller_runtimes = "controller"
          config.series_name_for_view_runtimes       = "view"
          config.series_name_for_db_runtimes         = "db"
        end
      end

    end
  end
end
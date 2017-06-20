module RedCross
  module Configuration
    class << self
      attr_accessor :influxdb_connect, :influxdb, :trackers, :default_tracker, :tracker, :logger

      def configure
        yield self
        @tracker = trackers[@default_tracker]
      end
    end
  end
end
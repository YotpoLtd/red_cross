module RedCross
  module Trackers
    class MonitorTracker < RedCross::Trackers::Base
      attr_accessor  :client

      def initialize(database = 'test', host = 'localhost', port = 8086, write_timeout = 0.05, read_timeout = 0.05, logger = false)
        InfluxDB::Logging.logger = logger
        @client = InfluxDB::Client.new database,
                                       host:  host,
                                       port:  port,
                                       async: true,
                                       retry: false,
                                       write_timeout:  write_timeout,
                                       read_timeout: read_timeout
      end

      def track(attrs, additional_args = {})
        monitor_request(attrs.merge(additional_args))
      end

      def identify(attrs, additional_args = {})
        {}
      end

      def flush
        {}
      end

      def monitor_request(attrs)
        return if client.nil?
        properties = attrs[:properties] || {}
        values = { count: 1 }.merge((properties.delete(:fields) || {}))
        begin
          client.write_point(attrs[:event], { values: values, tags: properties })
          client.writer.worker.stop!
        rescue => e
          RedCross::Log.error("Failed to send monitor data for event: #{attrs[:event]} , Error #{e.message}")
        end
      end
    end
  end
end

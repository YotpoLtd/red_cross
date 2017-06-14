module RedCross
  module Trackers
    class MonitorTracker < RedCross::Trackers::Base
      attr_accessor  :client

      def initialize(configs)
        configs = configs.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
        InfluxDB::Logging.logger = logger
        @client = InfluxDB::Client.new configs[:database],
                                       host:  configs[:host] || '127.0.0.1',
                                       port:  configs[:port] || 8086,
                                       async: true,
                                       retry: false,
                                       write_timeout: configs[:write_timeout] || 0.05,
                                       read_timeout: configs[:read_timeout] || 0.05
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

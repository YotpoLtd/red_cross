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
                                       write_timeout:  write_timeout.to_f,
                                       read_timeout: read_timeout.to_f
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
        event = attrs[:event].to_s
        properties = attrs[:properties] || {}
        values = { count: 1 }.merge((properties.delete(:fields) || {}))
        begin
          client.write_point(event, { values: compact(values), tags: compact(properties) })
          client.writer.worker.stop!
        rescue => e
          error_data = {
              log_message: 'Failed to send monitor data to InfluxDB',
              event_arguments: {
                  event: event,
                  tags: properties,
                  fields: values
              },
              exception: {
                  class: e.class.to_s,
                  message: e.message,
                  backtrace: e.backtrace
              }
          }
          log :error, error_data
        end
      end

      def compact(hash)
        hash.respond_to?(:compact) ? hash.compact : hash.delete_if {|k,v| v == nil }
      end
    end
  end
end

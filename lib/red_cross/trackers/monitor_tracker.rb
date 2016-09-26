module RedCross
  module Trackers
    class MonitorTracker < RedCross::Trackers::Base
      extend RedCross::Log
      attr_accessor  :client

      def initialize(database = '', host = '', port = '')
        return unless database.present? && host.present? && port.present?
        @client = InfluxDB::Client.new database,
                                       host:  host,
                                       port:  port,
                                       async: true,
                                       retry: false
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
        data = { values: { count: (attrs[:count] || 1) }, tags: attrs[:properties] }
        begin
          client.write_point(attrs[:event], data)
          client.writer.worker.stop!
        rescue => e
          RedCross.error("Failed to send monitor data for event: #{attrs[:event]} , Error #{e.message}")
        end
      end
    end
  end
end

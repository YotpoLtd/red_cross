require 'active_support/all'
module RedCross
  module Trackers
    class MonitorTracker < RedCross::Trackers::Base
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
#####################################################
# Application tracker
# send your metrics to influxdb using udp protocol
# Usage:
# RedCross.application_track(event: 'user.registration', properties: { referrer: 'facebook' } )
#####################################################
module RedCross
  module Trackers
    class ApplicationTracker < RedCross::Trackers::Base
      attr_accessor  :client

      def initialize(database = 'application_metrics', host, port)
        @client = InfluxDB::Client.new udp: {
                                           host:  host,
                                           port:  port,
                                       },
                                       discard_write_errors: true,
                                       database: database
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

      def group(attrs, additional_args = {})
        {}
      end

      def monitor_request(attrs)
        return if client.nil?
        event = attrs[:event].to_s
        properties = attrs[:properties] || {}
        values = { count: 1 }.merge((properties.delete(:fields) || {}))
        begin
          client.write_point(event, { values: compact(values), tags: compact(properties) })
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

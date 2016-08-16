require 'red_cross/version'
require 'red_cross/configuration'
require 'red_cross/logger'
require 'segment'
require 'resque/plugins/red_cross_async'
require 'resque'
require 'influxdb'

module RedCross
    class << self

      def track(attrs, topic = "")
        Configuration.segment.track(attrs)
      end

      def identify(attrs, topic = "")
        Configuration.segment.identify(attrs)
      end

      def flush
        Configuration.segment.flush
      end

      def monitor(attrs)
        return if Configuration.influxdb.nil?
        data = { values: { count: (attrs[:count] || 1) }, tags: attrs[:properties] }
        begin
          Configuration.influxdb.write_point(attrs[:event], data)
          Configuration.influxdb.writer.worker.stop!
        rescue => e
          Logging.logger.error("Failed to send monitor data for event: #{attrs[:event]} , Error #{e.message}")
        end
      end

    end
end

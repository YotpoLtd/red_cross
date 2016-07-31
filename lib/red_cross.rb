require 'red_cross/version'
require 'red_cross/configuration'
require 'segment'
require 'resque/plugins/red_cross_async'
require 'resque'
require 'influxdb-rails'


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

      # Measurement has to include event and properties
      def monitor(attrs)
        data = { values: { count: (attrs[:count] || 1) }, tags: attrs[:properties] }
        Configuration.influxdb.write_point(attrs[:event].snakecase , data)
        InfluxDB::Rails.client.stop!
      end

    end
end

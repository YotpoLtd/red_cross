require 'red_cross/version'
require 'red_cross/configuration'
require 'segment'
require 'typhoeus'
require 'resque'
require 'influxdb'
require 'red_cross/logging'
require 'red_cross/trackers/base'
require 'red_cross/trackers/segment_tracker'
require 'red_cross/trackers/http_tracker'
require 'red_cross/trackers/monitor_tracker'
require 'red_cross/trackers/application_tracker'
require 'production_e2e_filter'

include RedCross::ProductionE2EFilter

module RedCross
    class << self
      def track(attrs, topic = '')
        return if is_e2e_test_flow?(attrs[:event], attrs[:properties])
        Configuration.tracker.track(attrs)
      end

      def identify(attrs, topic = '')
        return if is_e2e_test_flow?('identify', attrs[:traits])
        Configuration.tracker.identify(attrs)
      end

      def flush
        Configuration.tracker.flush
      end

      def group(attrs, topic = '')
        return if is_e2e_test_flow?('group', attrs[:traits])
        Configuration.tracker.group(attrs)
      end

      def method_missing(m, *args, &block)
        match = /(.*?)_track/.match(m.to_s)
        tracker = match.captures.first.to_sym unless match.nil?
        super unless Configuration.trackers.keys.include? tracker
        Configuration.trackers[tracker].send(:track, *args)
      end
    end
end

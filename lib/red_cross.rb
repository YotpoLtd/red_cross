require 'red_cross/version'
require 'red_cross/configuration'
require 'segment'
require 'typhoeus'
require 'resque/plugins/red_cross_async'
require 'resque'
require 'red_cross/trackers/base'
require 'red_cross/trackers/segment_tracker'
require 'red_cross/trackers/http_tracker'

module RedCross
    class << self
      def track(attrs, topic = '')
        Configuration.tracker.track(attrs)
      end

      def identify(attrs, topic = '')
        Configuration.tracker.identify(attrs)
      end

      def flush
        Configuration.tracker.flush
      end

      def monitor(attrs)
        []
      end

      def method_missing(m, *args, &block)
        match = /(.*?)_track/.match(m.to_s)
        tracker = match.captures.first.to_sym unless match.nil?
        super unless Configuration.trackers.keys.include? tracker
        Configuration.trackers[tracker].send(:track, *args)
      end
    end
end

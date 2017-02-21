require 'multi_json'
module RedCross
  module Trackers
    class Log < RedCross::Trackers::Base
      def self.type
        :log
      end

      def initialize(path, name)
        @logger = Logger.new(path)
        @name = name
      end

      def track(attrs, additional_args = {})
        @logger.add(-1, MultiJson.dump({event: 'track', attrs: attrs, additional_args: additional_args}), @name )
      end

      def identify(attrs, additional_args = {})
        @logger.add(-1, MultiJson.dump({event: 'identify', attrs: attrs, additional_args: additional_args}), @name )
      end

      def flush
      end
    end
  end
end


require 'logger'
module RedCross
  module Logging

    class << self

      attr_writer :logger

      def logger
        @logger ||= ::Logger.new(STDERR)
      end
      
    end
  end
end

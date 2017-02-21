module RedCross
  module Configuration
    class << self
      def self.add_trackers_type(type, klass)
        @_trackers ||= {}
        if @_trackers[type].nil?
          @_trackers[type] = klass
        else
          raise "RedCross: traker of this type already exists #{type}"
        end
      end
      attr_accessor :logger
      def initialize(&block)
        @conf = {}
        yield self if block_given?
      end

      def provider(type, *args)
        if @@_trackers[type]
          @conf[type] = @@_trackers[type].new(*args)
        end
      end

      def logger= (logger)
        @logger = logger
      end

      def logger
        @logger
      end

      def track(attrs, topic = '')
        @conf.each_value{ |v| v.track(attrs, topic) }
      end

      def identify(attrs, topic = '')
        @conf.each_value{ |v| v.identify(attrs, topic) }
      end

      def flush
        @conf.each_value{ |v| v.flush }
      end
    end
  end
end
require 'red_cross/version'
require 'red_cross/configuration'

module RedCross
    class << self
      def track(attrs, topic = '')
        @conf.track(attrs, topic)
      end

      def identify(attrs, topic = '')
        @conf.identify(attrs, topic)
      end

      def flush
        @conf.flush()
      end

      def configure=(trackers)
        @conf = trackers
      end

      def log(level, message)
        if @conf.logger
          @conf.logger.send(level, message)
        end
      end

      %w( fatal error warn info debug unknown ).each do |severity|
        eval <<-EOM, nil, __FILE__, __LINE__ + 1
        def #{severity}(msg)
          if @conf.logger
            @conf.logger.#{severity} msg
          end
        end
        EOM
      end
    end
end

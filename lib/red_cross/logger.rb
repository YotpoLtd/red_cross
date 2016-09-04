require 'logger'
module RedCross
    module Log
        class << self
      
            attr_writer :logger
      
            def logger
                @logger ||= ::Logger.new(STDERR)
            end

            def error(message)
              logger.error message
            end
        end
    end
end
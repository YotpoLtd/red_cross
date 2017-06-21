require 'logger'
module RedCross
    module Logging

        def self.logger
            @logger ||= RedCross::Configuration.logger || (defined?(Rails) ? Rails.logger : ::Logger.new(STDERR))
        end

        def log(level, message)
            RedCross::Logging.logger.send(level.to_sym, message)
        rescue => e
            puts "RedCross failed to send log. Exception: #{e} \n Log message: #{message}"
        end
    end
end
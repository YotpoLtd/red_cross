require 'red_cross/version'
require 'red_cross/configuration'
require 'segment'
require 'resque/plugins/red_cross_async'
require 'resque'


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
  end
end

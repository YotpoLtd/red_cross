require 'red_cross/version'
require 'red_cross/configuration'
require 'segment'


module RedCross
  class << self
    def track(attrs, topic = "")
      Configuration.segment.track(attrs)
      Configuration.segment.flush
    end

    def identify(attrs, topic = "")
      Configuration.segment.identify(attrs)
      Configuration.segment.flush
    end
  end
end

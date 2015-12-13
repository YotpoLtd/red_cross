require 'red_cross/version'
require 'red_cross/configuration'
require 'segment'


module RedCross
  class << self
    def track(attrs, topic = "")
      Configuration.segment.track(attrs)
    end

    def identify(attrs, topic = "")
      Configuration.segment.identify(attrs)
    end
  end
end

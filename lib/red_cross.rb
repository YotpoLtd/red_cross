require 'red_cross/version'
require 'red_cross/configuration'
require 'segment'


module RedCross
  class << self
    def track(user_id, event, topic)
      Configuration.segment.track(
          {
              user_id: user_id,
              event: event
          }
      )
    end

    def identify(user_id, traits, topic)
      Configuration.segment.identify(
          {
              user_id: user_id,
              traits: traits
          }
      )
    end
  end
end

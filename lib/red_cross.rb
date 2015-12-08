require 'red_cross/version'
require 'red_cross/configuration'
require 'segment'


module RedCross
  class << self
    def track(user_id, event, topic)
      segment.track(
          {
              user_id: user_id,
              event: event
          }
      )
    end

    def identify(user_id, traits, topic)
      segment.identify(
          {
              user_id: user_id,
              traits: traits
          }
      )
    end

    private
    def segment
      @segment ||= Segment::Analytics.new({write_key: Configuration.segment_write_key})
    end
  end
end

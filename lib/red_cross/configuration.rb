module RedCross
  module Configuration
    class << self
      attr_accessor :path, :segment_write_key

      def configure
        yield self
      end
    end
  end
end
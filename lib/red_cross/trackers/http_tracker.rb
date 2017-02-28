module RedCross
  module Trackers
    class HttpTracker < RedCross::Trackers::Base
      class FailedPushingToEventbus < Exception
        def initialize(code, route, return_code)
          @code = code
          @route = route
          @return_code = return_code
        end

        def to_s
          "Failed pushing to Eventbus. Error code: #{@code}, route: #{@route} Error: #{@return_code.to_s}"
        end
      end
      attr_accessor :eventbus_host

      def initialize(host)
        @eventbus_host = host
      end

      def track(route, attrs, additional_args = {})
        eventbus_request(@eventbus_host + route, attrs.merge(additional_args), :post)
      end

      def identify(attrs, additional_args = {})
        {}
      end

      def flush
        {}
      end

      def eventbus_request(request_url, params, method = :get)
        request = Typhoeus::Request.new(
            request_url,
            method: method,
            params: method == :get ? params : {},
            body: method == :post ? params.to_json : {}
        )
        request.on_complete do |response|
          if response.success?
            return true
          else
            raise FailedPushingToEventbus.new(response.response_code ,request_url, response.return_code)
          end
        end
        request.run
      end
    end
  end
end

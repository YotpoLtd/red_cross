require 'typhoeus'
module RedCross
  module Trackers
    class Typhoeus < RedCross::Trackers::Base
      class FailedPushingToKafka < Exception
        def initialize(code, route, return_code)
          @code = code
          @route = route
          @return_code = return_code
        end

        def to_s
          "Failed pushing to Kafka. Error code: #{@code}, route: #{@route} Error: #{@return_code.to_s}"
        end
      end
      attr_accessor :clerk_host
      def self.type
        :typhoeus
      end
      def initialize(host)
        @clerk_host = host
      end

      def track(attrs, additional_args = {})
        clerk_request(@clerk_host,attrs.merge(additional_args), :post)
      end

      def identify(attrs, additional_args = {})
        {}
      end

      def flush
        {}
      end

      def clerk_request(request_url, params, method = :get)
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
            raise FailedPushingToKafka.new(response.response_code ,request_url, response.return_code)
          end
        end
        request.run
      end
    end
  end
end

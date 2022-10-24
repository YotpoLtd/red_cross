require 'yaml'
require 'erb'
require_relative 'red_cross/logging'

include RedCross::Logging

LOG_TAG = 'production_e2e_filter'

module RedCross
  module ProductionE2EFilter

    begin
      E2E_FILTER_CONF = YAML::load(ERB.new(IO.read(File.expand_path('../../conf/e2e_filter_conf.yml', __FILE__))).result)
      E2E_EMAILS = E2E_FILTER_CONF['PREFIXES']['EMAILS']
      E2E_DOMAINS = E2E_FILTER_CONF['PREFIXES']['DOMAINS']
      RedCross::Logging.log(:info, {
        log_tag: LOG_TAG,
        message: "Successfully initialized red_cross production e2e filter values"
      })
    rescue => e
      RedCross::Logging.log(:error, {
        log_tag: LOG_TAG,
        message: "Unable to initialize red_cross production e2e filter due to Exception: #{e.message}"
      })
    end

    def is_e2e_test_flow?(event_name, properties)
      begin
        return false unless is_filtering_enabled?
        skip_event = filter_email?(properties[:email]) || filter_domain?(properties[:website], properties[:storeDomain])
        if skip_event
          RedCross::Logging.log(:info, {
            log_tag: LOG_TAG,
            message: "Blocked sending #{event_name} for account with email: #{properties[:email]}, website: #{properties[:website]}, store domain: #{properties[:storeDomain]}"
          })
        end
        skip_event
      rescue => e
        RedCross::Logging.log(:error, {
          log_tag: LOG_TAG,
          message: "Failed to check for production e2e filter values due to Exception: #{e.message}"
        })
        false
      end
    end

    private

    def is_filtering_enabled?
      E2E_FILTER_CONF['EVENT_FILTERING_ENABLED']
    end

    def filter_email?(email)
      E2E_EMAILS.each do |test_prefix|
        return true if !email.nil? && email.start_with?(test_prefix)
      end
      false
    end

    def filter_domain?(*domain_candidates)
      E2E_DOMAINS.each do |test_prefix|
        domain_candidates.each do |domain_candidate|
          return true if !domain_candidate.nil? && domain_candidate.start_with?(test_prefix)
        end
      end
      false
    end

  end
end

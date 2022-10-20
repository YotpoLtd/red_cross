require 'yaml'
require 'erb'
require_relative 'red_cross/logging'

include RedCross::Logging

module RedCross
  module ProductionE2EFilter

    def self.log_tag
      'production_e2e_filter'
    end

    begin
      @e2e_filter_conf = YAML::load(ERB.new(IO.read(File.expand_path('../../conf/e2e_filter_conf.yml', __FILE__))).result)
      @e2e_emails = @e2e_filter_conf['PREFIXES']['EMAILS']
      @e2e_domains = @e2e_filter_conf['PREFIXES']['DOMAINS']
      RedCross::Logging.log(Logger::INFO, {
        log_tag: self.log_tag,
        message: "Successfully initialized red_cross production e2e filter values"
      })
    rescue => e
      RedCross::Logging.log(Logger::Error, {
        log_tag: self.log_tag,
        message: "Unable to initialize red_cross production e2e filter due to #{e.message}"
      })
    end

    def is_e2e_test_flow?(properties)
      begin
        return false unless is_filtering_enabled?
        filter_email?(properties[:email]) || filter_domain?(properties[:website], properties[:storeDomain]) ? true : false
      rescue => e
        RedCross::Logging.log(Logger::Error, {
          log_tag: self.log_tag,
          message: "Failed to check for production e2e filter values due to #{e.message}"
        })
        false
      end
    end

    private

    def is_filtering_enabled?
      @e2e_filter_conf['EVENT_FILTERING_ENABLED']
    end

    def filter_email?(email)
      @e2e_emails.each do |test_prefix|
        return true if email&.start_with?(test_prefix)
      end
      false
    end

    def filter_domain?(*domain_candidates)
      @e2e_domains.each do |test_prefix|
        domain_candidates.each do |domain_candidate|
          return true if domain_candidate.start_with?(test_prefix)
        end
      end
      false
    end

  end
end

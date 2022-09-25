require 'logger'

module ProductionE2EFilter
  def self.log_tag
    return 'production_e2e_filter'
  end

  BEGIN {
    logger = Logger.new(STDOUT)
    begin
      E2E_FILTER_CONF = YAML::load(ERB.new(IO.read(File.expand_path('./conf/e2e_filter_conf.yml', __FILE__))).result).with_indifferent_access
      @e2e_emails = E2E_FILTER_CONF['PREFIXES']['EMAILS']
      @e2e_domains = E2E_FILTER_CONF['PREFIXES']['DOMAINS']
      logger.info({
                    log_tag: self.log_tag,
                    message: "Successfully initialized red_cross production e2e filter values"
                  })
    rescue => e
      logger.error({
                     log_tag: self.log_tag,
                     message: "Unable to initialize red_cross production e2e filter due to #{e.message}"
                   })
    end
  }

  def is_e2e_test_flow?(properties)
    begin
      return false unless is_filtering_enabled?
      filter_email?(properties[:email]) || filter_domain?(properties[:website], properties[:storeDomain]) ? true : false
    rescue => e
      logger.error({
                     log_tag: self.log_tag,
                     message: "Failed to check for production e2e filter values due to #{e.message}"
                   })
      false
    end
  end

  private

  def is_filtering_enabled?
    E2E_FILTER_CONF['EVENT_FILTERING_ENABLED']
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

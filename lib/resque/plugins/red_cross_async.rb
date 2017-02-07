module Resque
  module Plugins
    module RedCrossAsync
      # Hash of properties for RedCross.monitor
      # Please add count: MY_NUMBER in case your metric value differs 1
      def properties(*args)
        {}
      end

      def before_perform_send_monitor_data(*args)
        @job_start_time = Time.now().to_f
        @job_end_time = @job_start_time
        send_metrics('before_perform', *args)
      end

      def after_perform_actions(*args)
        RedCross.flush
        @job_end_time = Time.now().to_f
        send_metrics('performed', *args)
      end

      def on_failure_send_monitor_data(e, *args)
        @job_end_time = Time.now().to_f
        send_metrics('failed', *args)
      end

      private

      def send_metrics(event_type, *args)
        properties = { class: self.name }.merge(properties(*args))
        properties.merge!({ fields: { run_time: ((@job_end_time - @job_start_time)*1000).to_i } }) unless event_type == 'before_perform'
        RedCross.monitor_track(event: 'resque_job_' + event_type, properties: properties)
      end
    end
  end
end

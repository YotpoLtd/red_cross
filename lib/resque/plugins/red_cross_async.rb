module Resque
  module Plugins
    module RedCrossAsync
      # Hash of properties for RedCross.monitor
      # Please add count: MY_NUMBER in case your metric value differs 1
      def properties(*args)
        {}
      end

      def after_perform_actions(*args)
        RedCross.flush
        send_metrics('performed', *args)
      end

      def before_perform_send_monitor_data(*args)
        send_metrics('before_perform', *args)
      end

      def on_failure_send_monitor_data(e, *args)
        send_metrics('failed', *args)
      end

      private

      def send_metrics(event_type, *args)
        RedCross.monitor_track(event: 'resque_job_' + event_type, properties: { class: self.name }.merge(properties(*args)))
      end
    end
  end
end

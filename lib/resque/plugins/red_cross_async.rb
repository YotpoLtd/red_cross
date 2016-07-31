module Resque
  module Plugins
    module RedCrossAsync
      # Hash of properties for RedCross.monitor
      # Please add count: MY_NUMBER in case your metric value differs 1
      def properties(*args)
        {}
      end

      def after_perform_flush(*args)
        RedCross.flush
      end

      def before_perform_send_monitor_data(*args)
        send_metrics('before_perform', *args)
      end

      def after_perform_send_monitor_data(*args)
        send_metrics('performed', *args)
      end

      def on_failure_send_monitor_data(*args)
        args.shift
        send_metrics('failed', *args)
      end

      private

      def send_metrics(event_type, *args)
        RedCross.monitor(event: 'resque_job_' + event_type, properties: { queue: @queue || queue }.merge(properties(*args)))
      end
    end
  end
end

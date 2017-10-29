module Resque
  module Plugins
    module RedCrossMonitor
      # Hash of properties for RedCross.monitor
      # Please add count: MY_NUMBER in case your metric value differs 1
      def job_method(*args)
        #Add the method that triggered by the job
        'no_method_job'
      end

      def before_schedule_send_monitor_data(*args)
        send_metrics('before_schedule', *args)
      end

      def after_schedule_send_monitor_data(*args)
        send_metrics('after_schedule', *args)
      end

      def before_delayed_enqueue_send_monitor_data(*args)
        send_metrics('before_delayed_enqueue', *args)
      end

      def before_enqueue_send_monitor_data(*args)
        send_metrics('before_enqueue', *args)
      end

      def after_enqueue_send_monitor_data(*args)
        send_metrics('after_enqueue', *args)
      end

      def before_perform_send_monitor_data(*args)
        @red_cross_job_start_time = Time.now()
        send_metrics('before_perform', *args)
      end

      def after_perform_actions(*args)
        ::RedCross.flush
        @red_cross_job_end_time = Time.now()
        send_metrics('performed', *args)
      end

      def on_failure_send_monitor_data(e, *args)
        @red_cross_job_end_time = Time.now()
        send_metrics('failed', *args)
      end

      def default_event_properties(*args)
        event_properties = { class: self.name, fields: { } }
        event_properties[:exception] = args.shift.class.to_s if args.is_a?(Array) && args[0].is_a?(Exception)
        queue = Resque.queue_from_class(self)
        (queue && !queue.to_s.empty?) ? event_properties[:queue] = queue : event_properties[:class]
        event_job_method = job_method(*args)
        if (!event_job_method.nil? && ([String, Integer, Symbol].include? event_job_method.class))
          event_properties[:event_method] = event_job_method
        else
          event_properties[:event_method] = 'no_valid_job_method'
        end
        event_properties
      end

      def send_metrics(job_status, *args)
        event_properties = default_event_properties(*args)
        event_properties[:fields][:run_time] = ((@red_cross_job_end_time.to_f - @red_cross_job_start_time.to_f)*1000).to_i if %w(performed failed).include? job_status
        ::RedCross.monitor_track(event: 'resque', properties: event_properties.merge({ job_status: job_status }))
      end
    end
  end
end

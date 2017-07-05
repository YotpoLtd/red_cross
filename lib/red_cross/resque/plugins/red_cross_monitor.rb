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
        @job_start_time = Time.now()
        send_metrics('before_perform', *args)
      end

      def after_perform_actions(*args)
        ::RedCross.flush
        @job_end_time = Time.now()
        send_metrics('performed', *args)
      end

      def on_failure_send_monitor_data(*args)
        @job_end_time = Time.now()
        send_metrics('failed', *args)
      end

      def default_event_properties(*args)
        @event_properties ||= { fields: {  } }
        @event_properties[:class] ||= self.name
        @event_properties[:queue] ||= Resque.queue_from_class(self)
        event_job_method = job_method(*args)
        if (!event_job_method.nil? && ([String, Integer, Symbol].include? event_job_method.class))
          @event_properties[:event_method] = event_job_method
        else
          @event_properties[:event_method] = 'no_valid_job_method'
        end
      end

      def send_metrics(job_status, *args)
        default_event_properties(*args)
        @event_properties[:fields][:run_time] = ((@job_end_time - @job_start_time)*1000).to_i if %w(performed failed).include? job_status
        if args.is_a?(Array) && args[0].is_a?(Exception)
          @event_properties[:exception] = args.shift.class.to_s
        end
        ::RedCross.monitor_track(event: 'resque', properties: @event_properties.merge({ job_status: job_status }))
      end
    end
  end
end

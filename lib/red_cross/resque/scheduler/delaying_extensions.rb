module Resque
  module Scheduler
    module DelayingExtensions
      alias default_last_enqueued_at last_enqueued_at
      def last_enqueued_at(name, timestemp)
        properties = {
            task_name: name,
            status: 'enqueued'
        }
        RedCross.track(event: 'resque_scheduler', properties: properties)
        default_last_enqueued_at(name, timestemp)
      end
    end
  end
end

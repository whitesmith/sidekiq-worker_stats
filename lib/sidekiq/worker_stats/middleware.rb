require 'sidekiq/worker_stats/configuration'
require 'sidekiq/worker_stats/stats'

module Sidekiq
  module WorkerStats
    class Middleware
      def call(worker, msg, queue)
        c = Sidekiq::WorkerStats::Configuration.new(worker.class)

        unless c.enabled
          yield
          return
        end

        s = Sidekiq::WorkerStats::Stats.new(worker, msg, queue, c)
        begin
          yield
          s.stop('completed')
        rescue => e
          s.stop('failed')
          raise e
        ensure
          s.save
        end
      end
    end
  end
end

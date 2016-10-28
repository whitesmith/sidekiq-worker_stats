module Sidekiq
  module WorkerStats
    class Middleware
      def call(worker, msg, queue)
        worker_stats = {}
        worker_stats[:start] = Time.now.to_i
        worker_stats[:status] = 'started'

        worker_stats[:pid] = Process.pid
        worker_stats[:jid] = worker.jid

        worker_stats[:page_size] = `getconf PAGESIZE`.to_i
        worker_stats[:mem] = {}
        worker_stats[:mem][Time.now.to_i] = `awk '{ print $2 }' /proc/#{worker_stats[:pid]}/statm`.strip.to_i * worker_stats[:page_size]

        thr = Thread.new do
          while true do
            sleep 1
            worker_stats[:mem][Time.now.to_i] = `awk '{ print $2 }' /proc/#{worker_stats[:pid]}/statm`.strip.to_i * worker_stats[:page_size]
          end
        end

        yield

        worker_stats[:status] = 'completed'
      rescue => e
        worker_stats[:status] = 'failed'

        raise e
      ensure
        worker_stats[:stop] = Time.now.to_i
        worker_stats[:runtime] = worker_stats[:start] - worker_stats[:stop]

        worker_stats[:queue] = queue
        worker_stats[:class] = worker.class.to_s
        
        thr.exit

        save_worker_stats worker_stats
      end

      private

      def save_worker_stats(worker_stats)
        puts worker_stats
      end
    end
  end
end

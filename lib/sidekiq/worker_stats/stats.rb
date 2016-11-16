require 'sidekiq'
require 'json'

module Sidekiq
  module WorkerStats
    class Stats
      attr_reader :pid
      attr_reader :jid
      attr_reader :queue
      attr_reader :klass
      attr_reader :args

      attr_reader :start
      attr_reader :stop
      attr_reader :walltime
      attr_reader :status
      attr_reader :page_size
      attr_reader :mem

      attr_reader :mem_thr
      attr_reader :config

      def initialize(worker, msg, queue, config)
        @config = config
        @queue = queue
        @klass = worker.class
        @pid = ::Process.pid
        @jid = worker.jid
        @args = msg["args"]
        @page_size = `getconf PAGESIZE`.to_i
        start
      end

      def start
        @status = 'started'
        @start = ::Time.now.to_f
        memory_measurement
      end

      def stop(status)
        @stop = ::Time.now.to_f
        @walltime = @stop - @start
        @status = status

        mem_thr.exit if mem_thr != nil
        @mem[::Time.now.to_f] = current_memory
      end

      def save
        worker_key = "#{@klass}:#{@start}:#{@jid}"
        data = {
          pid: @pid,
          jid: @jid,
          queue: @queue,
          class: @klass,
          args: @args,
          start: @start,
          stop: @stop,
          walltime: @walltime,
          status: @status,
          page_size: @page_size,
          mem: @mem
        }

        Sidekiq.redis do |redis|
          redis.hset ::Sidekiq::WorkerStats::REDIS_HASH, worker_key, JSON.generate(data)
        end
      end

      private

      def memory_measurement
        @mem = {}
        mem_sleep = @config.mem_sleep
        @mem_thr = ::Thread.new do
          while true do
            @mem[::Time.now.to_f] = current_memory
            sleep mem_sleep
          end
        end
      end

      def current_memory
        `awk '{ print $2 }' /proc/#{@pid}/statm`.strip.to_i * @page_size
      end
    end
  end
end

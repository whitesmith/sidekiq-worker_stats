module Sidekiq
  module WorkerStats
    class Configuration
      DEFAULT_MEM_SLEEP = 5.freeze
      DEFAULT_ENABLED = false.freeze

      attr_reader :klass

      def initialize(klass)
        @klass = klass
      end

      def mem_sleep
        @klass.get_sidekiq_options['worker_stats_mem_sleep'] || Sidekiq::WorkerStats::Configuration::DEFAULT_MEM_SLEEP
      end

      def enabled
        @klass.get_sidekiq_options['worker_stats_enabled'] || Sidekiq::WorkerStats::Configuration::DEFAULT_ENABLED
      end
    end
  end
end


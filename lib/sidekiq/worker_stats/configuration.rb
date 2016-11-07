module Sidekiq
  module WorkerStats
    class Configuration
      attr_accessor :log_file
      attr_accessor :time

      def initialize
        @log_file = 'log/sidekiq.log'
        @time = 5
      end
    end
  end
end

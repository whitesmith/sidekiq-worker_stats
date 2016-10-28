module Sidekiq
  module WorkerStats
    class Configuration
      attr_writer :log_file

      def initialize
        @log_file = 'log/sidekiq.log'
      end
    end
  end
end

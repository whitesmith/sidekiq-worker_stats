require 'sidekiq'

require 'sidekiq/worker_stats/configuration'
require 'sidekiq/worker_stats/middleware'
require 'sidekiq/worker_stats/web' if defined?(Sidekiq::Web)

module Sidekiq
  module WorkerStats
    REDIS_HASH = 'sidekiq:worker_stats'.freeze

    class << self
      attr_writer :configuration

      def configuration
        @configuration ||= Configuration.new
      end

      def configure
        yield(configuration)
      end
    end
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Sidekiq::WorkerStats::Middleware
  end
end


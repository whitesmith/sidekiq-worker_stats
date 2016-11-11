require 'sidekiq'

require 'sidekiq/worker_stats/middleware'
require 'sidekiq/worker_stats/web' if defined?(Sidekiq::Web)

module Sidekiq
  module WorkerStats
    REDIS_HASH = 'sidekiq:worker_stats'.freeze
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Sidekiq::WorkerStats::Middleware
  end
end


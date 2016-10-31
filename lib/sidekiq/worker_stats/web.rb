require 'json'

require 'sidekiq/web' unless defined?(Sidekiq::Web)

module Sidekiq
  module WorkerStats
    module Web
      def self.registered(app)
        view_path = File.join(File.expand_path('..', __FILE__), 'views')

        app.get '/worker_stats' do
          @workers = {}
          Sidekiq.redis do |redis|
            keys = redis.hkeys REDIS_HASH
            keys.each do |key|
              @workers[key] = JSON.parse(redis.hget(REDIS_HASH, key))
            end
          end

          render(:erb, File.read(File.join(view_path, 'worker_stats.erb')))
        end

        app.get '/worker_stats/:key' do
          @key = params[:key]
          @worker = {}
          Sidekiq.redis do |redis|
            @worker = JSON.parse(redis.hget(REDIS_HASH, @key))
          end

          render(:erb, File.read(File.join(view_path, 'worker_stats_single.erb')))
        end
      end
    end
  end
end

Sidekiq::Web.register Sidekiq::WorkerStats::Web
Sidekiq::Web.tabs['Worker Stats'] = 'worker_stats'

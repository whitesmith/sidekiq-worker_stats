require 'json'

require 'sidekiq/web' unless defined?(Sidekiq::Web)

module Sidekiq
  module WorkerStats
    module Web
      def self.registered(app)
        view_path = File.join(File.expand_path('..', __FILE__), 'views')

        app.get '/worker_stats' do
          @page = params["page"].to_i || 1
          @page = @page >= 1 ? @page - 1 : 0

          @per_page = params["per_page"].to_i || 10
          @per_page = @per_page >= 1 ? @per_page : 10

          @workers_stats = {}

          Sidekiq.redis do |redis|
            keys = redis.hkeys REDIS_HASH
            keys.each do |key|
              worker_stats = redis.hget(REDIS_HASH, key)
              @workers_stats[key] = JSON.parse(worker_stats) if worker_stats != nil
            end
          end
          @workers_stats = @workers_stats.sort_by { |k, v| ::Time.at(v["start"]) }.reverse
          @stats_length = @workers_stats.length

          @max_pages = (@stats_length / @per_page) - (@stats_length % @per_page == 0 ? 1 : 0)
          @page = @page * @per_page < @workers_stats.length ? @page : @max_pages
         
          down_limit = @page * @per_page
          up_limit   = ((@page + 1) * @per_page) - 1

          @workers_stats = @workers_stats[down_limit..up_limit] || @workers_stats[0..@per_page-1]

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

if defined?(Sidekiq::Web)
  Sidekiq::Web.register Sidekiq::WorkerStats::Web
  Sidekiq::Web.tabs['Worker Stats'] = 'worker_stats'
end

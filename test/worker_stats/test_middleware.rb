require 'minitest/autorun'

require 'rack/test'

require 'sidekiq'
require 'sidekiq/testing'
require 'sidekiq/worker_stats'

class BasicWorker
  include Sidekiq::Worker

  sidekiq_options({
    worker_stats_enabled: true,
    worker_stats_mem_sleep: 1
  })

  def perform
    # Let's use some memory
    a = []
    for i in 1..5000000
      a << i.to_s * 10
    end
  end
end

class NoStatsWorker
  include Sidekiq::Worker

  sidekiq_options({
    worker_stats_enabled: false
  })

  def perform
  end
end

class ErrorWorker
  include Sidekiq::Worker

  sidekiq_options({
    worker_stats_enabled: true,
    worker_stats_mem_sleep: 1
  })

  def perform
    raise StandardError.new("Error")
  end
end

class TestMiddleware < Minitest::Test
  def setup
    Sidekiq::Testing.server_middleware do |chain|
      chain.add Sidekiq::WorkerStats::Middleware
    end
  end

  def test_basic_worker_stats_are_saved
    Sidekiq::Testing.inline! do
      BasicWorker.perform_async
    end
  end

  def test_no_stats_worker
    Sidekiq::Testing.inline! do
      NoStatsWorker.perform_async
    end
  end

  def test_that_middleware_raises_error
    Sidekiq::Testing.inline! do
      assert_raises StandardError do
        ErrorWorker.perform_async
      end
    end
  end
  
  def test_that_middleware_reports_end
    skip 'todo'
  end

end

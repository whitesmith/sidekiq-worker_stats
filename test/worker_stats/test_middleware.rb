require 'minitest/autorun'

require 'sidekiq'
require 'sidekiq/testing'
require 'sidekiq/worker_stats'

class WorkerHelper
  include Sidekiq::Worker

  def perform
    # Let's use some memory
    a = []
    for i in 1..10000000
      a << i.to_s * 10
    end
  end
end

class ErrorWorkerHelper
  include Sidekiq::Worker

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

  def test_that_middleware_reports_start
    Sidekiq::Testing.inline! do
      WorkerHelper.perform_async
    end
  end

  def test_that_middleware_reports_end
    skip 'todo'
  end

  def test_that_middleware_reports_error
    Sidekiq::Testing.inline! do
      assert_raises StandardError do
        ErrorWorkerHelper.perform_async
      end
    end
  end
end

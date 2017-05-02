# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sidekiq/worker_stats/version'

Gem::Specification.new do |s|
  s.name          = 'sidekiq-worker_stats'
  s.version       = Sidekiq::WorkerStats::VERSION
  s.license       = 'MIT'
  s.summary       = 'System statistics for your sidekiq workers'
  s.description   = 'Save and analyze your workers statistics'

  s.authors       = ['Alexandre Jesus']
  s.email         = ['adbjesus@gmail.com']
  s.homepage      = 'https://github.com/whitesmith/sidekiq-worker_stats'

  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency 'sidekiq', '>= 4.1.4', '< 6'
  s.add_dependency 'redis', '~> 3.3', '>= 3.3.0'

  s.add_development_dependency 'minitest', '~> 5.0'
  s.add_development_dependency 'rack-test', '~> 0.6'
  s.add_development_dependency 'byebug', '~> 3.5'
  s.add_development_dependency 'rake', '~> 11.3'
end

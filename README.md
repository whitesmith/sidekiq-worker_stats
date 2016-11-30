# sidekiq-worker\_stats
**Statistics for sidekiq workers**

[![CircleCI](https://circleci.com/gh/whitesmith/sidekiq-worker_stats.svg?style=svg)](https://circleci.com/gh/whitesmith/sidekiq-worker_stats)

The following statistics are saved for analysis:

* Start Time
* Stop Time
* Runtime
* Memory

## Installation

Add `sidekiq-worker_stats` to your Gemfile

```ruby
gem 'sidekiq-worker_stats'
```

and install

```bash
$ bundle install
```

then simply require `sidekiq/worker_stats` after your `sidekiq` requirement.

```ruby
require 'sidekiq'
require 'sidekiq/worker_stats'
```

## Sidekiq web - worker\_stats tab

Require `sidekiq/worker_stats/web` after `sidekiq/web`.

```ruby
require 'sidekiq/web'
require 'sidekiq/worker_stats/web'
```

## Configuration

By default sidekiq-worker\_stats is disabled for every worker. To activate include `worker_stats_enabled: true` in your `sidekiq_options`.

All configurations you can include on `sidekiq_options`

| Configuration | Type | Default | Description |
|---------------|------|---------|-------------|
| `worker_stats_enabled` | boolean | false | Whether `worker_stats` should be enabled for this worker or not |
| `worker_stats_mem_sleep ` | number | 5 | How many seconds to wait between each memory measurement |
| `worker_stats_max_samples ` | number | 1000 | How many samples to keep for a given worker, it will delete the oldest samples first |


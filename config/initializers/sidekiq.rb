REDIS_CONN = proc do
  host =     ENV['REDIS_HOST']
  port =     ENV['REDIS_PORT']

  redis_ready = host.present? and port.present?

  redis_url = if redis_ready
    "redis://#{host}:#{port}/"
  else
    "redis://localhost:6379/"
  end

  r = Redis.new(url: redis_url)
  Redis::Namespace.new("sidekiq", redis: r)
end

Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: Sidekiq.options[:concurrency] + 2, timeout: 1, &REDIS_CONN)
end

Sidekiq.configure_server do |config|
  config.redis = ConnectionPool.new(size: Sidekiq.options[:concurrency] + 4, timeout: 1, &REDIS_CONN)

  config.server_middleware do |chain|
    chain.remove Sidekiq::Middleware::Server::RetryJobs
  end
end
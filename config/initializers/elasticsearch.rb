ELASTICSEARCH_CONFIG = proc do
  host =     ENV['ELASTIC_HOST']
  port =     ENV['ELASTIC_PORT']

  elastic_ready = host.present? and port.present?

  elasticsearch_url = if elastic_ready
    "http://#{host}:#{port}"
  else
    "http://localhost:9200"
  end
end

Elasticsearch::Model.client = Elasticsearch::Client.new(url: ELASTICSEARCH_CONFIG.call,  retry_on_failure: 5)

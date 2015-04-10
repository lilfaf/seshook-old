# Connect to specific Elasticsearch cluster
ELASTICSEARCH_URL = ENV['ELASTICSEARCH_URL'] || ENV['ELASTICSEARCH_PORT_9200_TCP'] || 'http://localhost:9200'

Elasticsearch::Model.client = Elasticsearch::Client.new host: ELASTICSEARCH_URL
backend: cd backend && bundle exec rails s -b 0.0.0.0
frontend: cd frontend && ember server -p 4200 --proxy http://localhost:3000
sidekiq: cd backend && bundle exec sidekiq -C config/sidekiq.yml
redis: redis-server /usr/local/etc/redis.conf
elasticsearch: elasticsearch --config=/usr/local/opt/elasticsearch/config/elasticsearch.yml
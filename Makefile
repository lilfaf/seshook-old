test:
	cd backend && bundle exec rspec && cd -
	cd frontend && ember test

install:
	cd backend && bundle install && cd -
	cd frontend && npm install && bower install

prepare:
	cd backend && bundle exec rake db:setup
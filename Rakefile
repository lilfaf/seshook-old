namespace :docker do
  task :build => ['docker:build:app', 'docker:build:worker']

  namespace :build do
    task :app do
      sh 'ln -snf dockerfiles/app/Dockerfile Dockerfile'
      sh 'docker build -t seshook-app .'
      sh 'rm -f Dockerfile'
    end

    task :worker do
      sh 'ln -snf dockerfiles/worker/Dockerfile Dockerfile'
      sh 'docker build -t seshook-worker .'
      sh 'rm -f Dockerfile'
    end
  end
end

task :install do
  sh 'cd backend && bundle install && cd -'
  sh 'cd frontend && npm install && bower install'
end

task :prepare do
  sh 'cd backend && bundle exec rake db:setup'
end

task :test do
  sh 'cd backend && bundle exec rspec && cd -'
  sh 'cd frontend && ember test'
end

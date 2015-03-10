namespace :docker do
  task :build => ['docker:build:app', 'docker:build:worker']

  namespace :build do
    task :app do
      sh 'ln -snf Dockerfile.app Dockerfile'
      sh 'docker build -t seshook-app .'
      sh 'rm -f Dockerfile'
    end

    task :worker do
      sh 'ln -snf Dockerfile.worker Dockerfile'
      sh 'docker build -t seshook-worker .'
      sh 'rm -f Dockerfile'
    end
  end
end
FROM phusion/passenger-ruby22:0.9.15
MAINTAINER Seshook "admin@seshook.com"

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Install bundle of gems
RUN mkdir -p /home/app/webapp/backend
ADD backend/Gemfile* /home/app/webapp/backend/
WORKDIR /home/app/webapp/backend
RUN bundle install

# Add application to image
ADD . /home/app/webapp/
RUN chown -R app:app /home/app/webapp
# Precompile assets
RUN RAILS_ENV=development bundle exec rake assets:precompile assets:clean

# Start nginx
EXPOSE 80
RUN rm -f /etc/service/nginx/down
RUN rm -f /etc/nginx/sites-enabled/default

ADD backend/config/deploy/webapp.conf /etc/nginx/sites-enabled/webapp.conf
ADD backend/config/deploy/rails-env.conf /etc/nginx/main.d/rails-env.conf

# Config sidekiq service
RUN useradd sidekiq
RUN chown -R sidekiq /home/app/webapp/backend/public/uploads
RUN mkdir /etc/service/sidekiq
ADD backend/config/deploy/sidekiq.sh /etc/service/sidekiq/run

# Clean up APT and bundler when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

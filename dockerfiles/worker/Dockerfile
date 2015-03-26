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

# Create sidekiq user and upload dir
RUN useradd sidekiq
RUN mkdir -p /home/app/webapp/backend/public/uploads
RUN chown -R sidekiq /home/app/webapp/backend/public/uploads

# Start sidekiq
RUN mkdir /etc/service/sidekiq
ADD backend/config/deploy/sidekiq.sh /etc/service/sidekiq/run

# Clean up APT and bundler when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

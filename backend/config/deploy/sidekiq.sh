#!/bin/sh
cd /home/app/webapp/backend
exec 2>&1
exec /sbin/setuser app bundle exec sidekiq \
  -e production \
  -C ./config/sidekiq.yml \
  -L ./log/sidekiq.log

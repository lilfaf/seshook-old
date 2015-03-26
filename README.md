Seshook
================

[![Circle CI](https://circleci.com/gh/lilfaf/seshook/tree/master.svg?style=shield&circle-token=0b40d28afab1220f4928e97a46edbb3e350a2f04)](https://circleci.com/gh/lilfaf/seshook/tree/master)

## Requirements

- Ruby 2.2
- [Bundler](http://bundler.io/) `gem install bundler`
- Postgresql w/ Postgis
- Redis
- Node.js
- [Ember CLI](http://www.ember-cli.com/) `npm install -g ember-cli`
- [Bower](http://bower.io/) `npm install -g bower`
- [PhantomJS](http://phantomjs.org/) `npm install -g phantomjs`

## Usage

Install dependencies and setup database

```bash
rake install && rake prepare
```

Start web server

```bash
foreman start
```

## Testing

Running all tests

```bash
rake test
```

Or run frontend and backend tests independently

```bash
# ember
cd frontend && ember test
# rails
cd backend && rspec spec
```

## Samples

Generate sample from photos with  exif metadata

```bash
cd backend && rake samples:seed
```

#### Environment variables

Customise images directory path with `IMAGES_PATH`, defaults to `./images`

Set `USE_REDIS_CACHE=true` to cache geocoder responses

## Docker environment

Install requirements

- Vmware Fusion or VirtualBox
- Docker
- [docker-machine](https://docs.docker.com/machine/) `brew cask install docker-machine`
- [docker-compose](https://docs.docker.com/compose/) `brew install docker-compose`

To run docker containers on a your local machine you must create a docker host virtual machine.

```bash
# Vmware Fusion
docker-machine create -d vmwarefusion dev
# or VirtualBox
docker-machine create -d virtualbox dev

$(docker-machine env dev)
```

Build containers

```bash
rake docker:build

# or build images individually
rake docker:build:app
rake docker:build:worker
```

Setup database and launch all containers

```bash
docker-compose run web bundle exec rake db:create db:setup RAILS_ENV=production
docker-compose up

open http://$(docker-machine ip dev)
```

## License

© Seshook 2015

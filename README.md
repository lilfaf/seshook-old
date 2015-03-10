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
make install && make prepare
```

Start web server

```bash
foreman start
```

## Testing

Running all tests

```bash
make test
```

Or run frontend and backend tests independently

```bash
# ember
cd frontend && ember test
# rails
cd backend && rake test
```

## Samples

Generate sample from photos with  exif metadata

```bash
cd backend && rake samples:seed
```

#### Environment variables

Customise images directory path with `IMAGES_PATH`, defaults to `./images`

Set `USE_REDIS_CACHE=true` to cache geocoder responses

## Running on Docker

Install requirements

- Vmware Fusion
- Docker
- [docker-machine](https://docs.docker.com/machine/) `brew cask install docker-machine`
- [docker-compose](https://docs.docker.com/compose/) `brew install docker-compose`

Create docker host vm

```bash
docker-machine create -d vmwarefusion dev
$(docker-machine env dev)
```

Build and run containers

```bash
docker-compose build web
docker-compose run -e RAILS_ENV=production web bundle exec rake db:create db:migrate db:seed
docker-compose up
```

## License

© Seshook 2015

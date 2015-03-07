FROM ruby:2.2

RUN apt-get update && apt-get install -y nodejs

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN git clone https://github.com/lilfaf/seshook.git /usr/src/app
RUN bundle install

EXPOSE 3000
CMD rails s

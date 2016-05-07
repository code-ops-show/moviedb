FROM ruby:2.3.1-alpine
MAINTAINER Zack Siri <zack@codemy.net>

RUN apk add --update build-base \
                     libxml2-dev \
                     libxslt-dev \
                     postgresql-dev \
                     && rm -rf /var/cache/apk/*

RUN bundle config build.nokogiri --use-system-libraries

RUN mkdir /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app

RUN bundle install --path vendor/bundle --without development test doc --deployment --jobs=4
RUN DB_ADAPTER=nulldb bundle exec rake assets:precompile
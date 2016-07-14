FROM ruby:2.3.1-alpine
MAINTAINER Zack Siri <zack@codemy.net>

RUN apk --update add --virtual build-dependencies \ 
                               build-base \
                               libxml2-dev \
                               libxslt-dev \
                               postgresql-dev \
                               nodejs \
                               tzdata \
                               && rm -rf /var/cache/apk/*


RUN mkdir /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app

RUN gem update bundler
RUN bundle install --path vendor/bundle --without development test doc --deployment --jobs=4
RUN DB_ADAPTER=nulldb bundle exec rake assets:precompile
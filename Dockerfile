FROM ruby:2.2.3

RUN apt-get update --qq & apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /app
WORKDIR /tmp

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

ADD . /app
WORKDIR /app
RUN RAILS_ENV=production bundle exec rake assets:precompile --trace
CMD ["rails", "server", "-b", "0.0.0.0"]


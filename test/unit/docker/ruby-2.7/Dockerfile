FROM ruby:2.7

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/

RUN gem install bundler
RUN bundle install --with test

COPY . /app

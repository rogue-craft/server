FROM ruby:2.7

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/

RUN gem install bundler

COPY . /app

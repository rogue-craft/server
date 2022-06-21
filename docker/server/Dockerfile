FROM ruby:3.1-bullseye

WORKDIR /srv

ADD run.rb /srv/run.rb
ADD docker/server/entrypoint.sh /entrypoint.sh

ADD Gemfile .
ADD Gemfile.lock .
RUN bundle install

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

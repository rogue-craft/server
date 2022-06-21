FROM ruby:3.1-bullseye

WORKDIR /srv

ADD docker/admin/entrypoint.sh /entrypoint.sh

ADD admin/Gemfile .
ADD admin/Gemfile.lock .
RUN bundle install

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

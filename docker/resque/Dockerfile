FROM ruby:3.1-bullseye

WORKDIR /srv

ADD Rakefile /srv/Rakefile
ADD docker/resque/entrypoint.sh /entrypoint.sh

ADD Gemfile .
ADD Gemfile.lock .
RUN bundle install

# RUN apt-get update && \
#     apt-get install -y sendmail

# RUN echo "include(\`/etc/mail/tls/starttls.m4')dnl" >> /etc/mail/sendmail.mc;
# RUN echo "include(\`/etc/mail/tls/starttls.m4')dnl" >> /etc/mail/submit.mc;

# RUN sendmailconfig && service sendmail restart

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

FROM redis:7-bullseye

WORKDIR /srv

ADD redis.conf /redis.conf
ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

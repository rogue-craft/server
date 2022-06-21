FROM redis:7-bullseye

ADD redis.conf /redis.conf
ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

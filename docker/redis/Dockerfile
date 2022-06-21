FROM redis:7-bullseye

WORKDIR /srv

ARG config

ADD redis.conf.common /redis.conf
ADD ${config} /${config}

RUN cat /${config} >> /redis.conf

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

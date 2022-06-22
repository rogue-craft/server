#!/bin/bash

cd admin

if [ $ADMIN_ENV = "development" ];
then
    gem install rerun

    rerun bundle exec "padrino start -h ${ADMIN_HOST} -e ${ADMIN_ENV}" --no-notify --background
else
    bundle exec padrino start -h ${ADMIN_HOST} -e ${ADMIN_ENV}
fi

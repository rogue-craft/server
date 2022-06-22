#!/bin/bash

bundle exec rake resque:work

if [ $ENV = "development" ];
then
    gem install rerun

    rerun bundle exec "bundle exec rake resque:work" --no-notify --background
else
    bundle exec rake resque:work
fi

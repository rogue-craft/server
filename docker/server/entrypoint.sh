#!/bin/bash

if [ $ENV = "development" ];
then
    gem install rerun

    rerun bundle exec ruby run.rb --no-notify --background
else
    bundle exec ruby run.rb
fi

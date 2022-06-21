#!/bin/bash

cd admin

bundle exec padrino start -h 0.0.0.0 -e ${ENV}

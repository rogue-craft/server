#!/bin/bash

mkdir -p /run/redis
chown -R redis:redis /run/redis

redis-server /redis.conf

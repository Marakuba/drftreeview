#!/usr/bin/env bash

./bin/local_build.sh

docker compose -f docker-compose.yml -p drftreeview up --abort-on-container-exit "${@}"

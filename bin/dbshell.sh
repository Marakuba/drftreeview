#!/usr/bin/env bash

docker exec -it "$(docker ps -q -f name="drftreeview-postgres")" \
  psql -d postgres -U postgres "${@}"

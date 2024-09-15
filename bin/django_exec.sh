#!/usr/bin/env bash

docker exec -it "$(docker ps -q -f name="drftreeview-web")" \
  python manage.py "${@}"

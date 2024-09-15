#!/usr/bin/env bash

./bin/django_exec.sh makemigrations "${@}"

./bin/_chown.sh

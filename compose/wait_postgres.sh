#!/usr/bin/env bash

set -o errexit
set -o pipefail

if test -z "$DATABASE_URL_FILE"
then
    DATABASE_URL=$DATABASE_URL
else
    DATABASE_URL=$(cat "$DATABASE_URL_FILE")
fi

postgres_ready() {
python3 << END
import sys

import psycopg2
from psycopg2.extensions import parse_dsn

try:
    psycopg2.connect(**parse_dsn("${DATABASE_URL}"))
except psycopg2.OperationalError:
    sys.exit(-1)
sys.exit(0)

END
}
until postgres_ready; do
  >&2 echo 'Waiting for PostgreSQL to become available...'
  sleep 1
done
>&2 echo 'PostgreSQL is available'

#!/usr/bin/env bash

function help() {
  echo "Usage: ./bin/test_run.sh [--path tests/tests/test_openapi.py] [--processes 0] [--stack drftreeview] [--log-level DEBUG] [--cov] [--html] [--term]"
  echo "Run automatic tests."
  echo
  echo "Options:"
  echo "   --path          Optional; tests search path inside the container;"
  echo "                   app root is '/tests/app'; default value is 'tests/app';"
  echo "                   path should start with package name inside 'app/', e.g. 'app/schedule/...'."
  echo "   --processes     Optional; the number of processes to run tests;"
  echo "                    - '0' (default): run in serial mode;"
  echo "                    - positive number: the number of processes will be equal to that number;"
  echo "                    - 'auto': the number of processes will be equal to the number of physical CPU cores;"
  echo "                    - 'logical': the number of processes will be equal to the number of logical CPU cores."
  echo "   --stack         Optional; stack name (used in CI)."
  echo "   --log-level     Optional; set log level for Django & Celery. Default level if ERROR."
  echo "   --cov           Flag; optional; run celery in synchronous mode in a sake of coverage."
  echo "   --html          Flag; optional; parses junit report to html"
  echo "   --term          Flag; optional; tells coverage to also print coverage report to stdout;"
  echo "                   can be used together with '--cov' only."
  echo
}

LOG_LEVEL=ERROR
COMPOSE_FILES="-f docker-compose-test.yml -f docker-compose-test-celery.override.yml"
STACK_NAME=drftreeview-test
export PROCESSES_NUM=0
export COV=0
export HTML=0

while [[ $# -gt 0 ]]
do
  case "$1" in
    --path)
      export TESTS_SEARCH_PATH=/app/tests/$2
      shift
      shift
      ;;
    --stack)
      export STACK_NAME=$2
      shift
      shift
      ;;
    --processes)
      export PROCESSES_NUM=$2
      shift
      shift
      ;;
    --cov)
      export DJANGO_SETTINGS_MODULE="drftreeview.settings.test_cov"
      export COV=1
      COMPOSE_FILES="-f docker-compose-test.yml"
      shift
      ;;
    --html)
      export HTML=1
      shift
      ;;
    --term)
      export COVERAGE_REPORT_FORMAT=term
      shift
      ;;
    --log-level)
      LOG_LEVEL=$2
      shift
      shift
      ;;
    --help)
      help
      exit 0
      ;;
    *)
      echo "ERROR: invalid option: $1"
      echo
      help
      exit 1
      ;;
  esac
done

# shellcheck disable=SC2086
docker compose $COMPOSE_FILES -p $STACK_NAME build

SECRET_KEY=$(echo $RANDOM | md5sum | head -c 32)
export SECRET_KEY
export LOG_LEVEL

# shellcheck disable=SC2086
docker compose $COMPOSE_FILES \
  -p $STACK_NAME up \
  --exit-code-from web \
  --abort-on-container-exit \
  --attach web

EXIT_CODE=$?

# Cleanup

# shellcheck disable=SC2086
# docker compose $COMPOSE_FILES -p $STACK_NAME down

rm -f ./app/pyproject.toml

exit $EXIT_CODE

poetry update
poetry export --without-hashes --with dev -o requirements-dev.txt

if [ "$1" = "prod" ]; then
  poetry export --without-hashes -o requirements.txt
  add_repo requirements.txt
fi

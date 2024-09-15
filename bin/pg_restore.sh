#!/usr/bin/env bash

# shellcheck disable=SC2207
LIST_BACKUPS=($(find "./volumes/postgres/backup" -type f -regex ".*\.backup"))

if [ ${#LIST_BACKUPS[@]} -eq 0 ]; then
  echo
  echo "No backup files found. Backup file must have 'backup' ext. Copy backup:"
  echo "  cp <path>/dump.backup ./volumes/postgres/backup/"
  echo
  exit 1
fi

echo
echo "List of backup files: "
echo
for i in "${!LIST_BACKUPS[@]}"; do
  printf "  %s -> %s\n" "$i" "$(basename "${LIST_BACKUPS[$i]}")"
done
echo
echo "IMPORTANT: backup restore operation will remove PostgreSQL data volume"
echo
read -r -p "Which backup would you like to restore? (enter number): " NUM

BACKUP_PATH="${LIST_BACKUPS[$NUM]}"

test ! -n "$BACKUP_PATH" && echo "You must enter a correct backup number" && exit 1

BACKUP_FN=$(basename "$BACKUP_PATH")

docker container stop drftreeview-postgres-1 2>/dev/null
docker container rm -f drftreeview-postgres-1 2>/dev/null
docker volume rm -f drftreeview_postgres_data &>/dev/null

./bin/local_build.sh postgres

docker compose -f docker-compose.yml -p drftreeview up -d postgres

# shellcheck disable=SC2046
export $(grep DATABASE_URL "./compose/env.local")

docker exec -t -e DATABASE_URL="$DATABASE_URL" \
  "$(docker ps -q -f name="drftreeview-postgres")" \
  ./wait_postgres.sh

docker exec -e PGPASSWORD=postgres \
  -it "$(docker ps -q -f name="drftreeview-postgres")" \
  pg_restore \
  "/backup/$BACKUP_FN" \
  --verbose \
  -O \
  -x \
  -d postgres \
  -U postgres

./bin/local_stop.sh

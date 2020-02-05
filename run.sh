#!/bin/bash
touch /mysql_backup.log
tail -F /mysql_backup.log &

echo "Listing current backups"
ls -la /backup

if [ "${INIT_BACKUP}" -gt "0" ]; then
  echo "=> Create a backup on the startup"
  /backup.sh
elif [ -n "${INIT_RESTORE_LATEST}" ]; then
  echo "=> Restore latest backup"
  until nc -z "$MYSQL_HOST" "$MYSQL_PORT"
  do
      echo "waiting database container..."
      sleep 1
  done
find /backup -maxdepth 1 -name '*.sql.gz' | tail -1 | xargs /restore.sh
fi


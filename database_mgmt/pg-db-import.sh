#!/usr/bin/env bash

# Add vars
DB_HOST=$1
DB_USER=$2
DB_IMPORT=$3
DB_NAME=${4:-my_test}

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <db_host> <db_user> <import_file> <db_name>"
  echo
  echo "import_file: The pg_dump file you want to run pg_restore with"
  echo "db_name: The (optional) name of the database you want to do a fresh import into"
  echo "         If you don't supply db_name it will import into my_test"
  exit 1
fi

echo "Dropping and creating database: ${DB_NAME}..."
dropdb --if-exists --h ${DB_HOST} -U ${DB_USER} ${DB_NAME}
createdb -e --h ${DB_HOST} -U ${DB_USER} ${DB_NAME}
echo "psql restore from ${DB_IMPORT}..."
time psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -f ${DB_IMPORT}

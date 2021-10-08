#!/bin/bash
set -e

function create_user_and_database() {
	local db=$1
	echo "  Creating user and database '$db'"
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
		CREATE USER $db;
		ALTER USER $db with encrypted password '$POSTGRES_PASSWORD';
		CREATE DATABASE $db;
		GRANT ALL PRIVILEGES ON DATABASE $db TO $db;
EOSQL
}

function update_database_with_postgis() {
    local db=$1
    echo "  Updating databse '$db' with extension"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$db" <<-EOSQL
		CREATE EXTENSION IF NOT EXISTS postgis;
		GRANT ALL ON geometry_columns TO PUBLIC;
		GRANT ALL ON spatial_ref_sys TO PUBLIC;
EOSQL
}

if [ -n "$POSTGRES_DB" ]; then
	echo "RiskChanges database creation requested: $POSTGRES_DB"
	create_user_and_database $POSTGRES_DB
	update_database_with_postgis $POSTGRES_DB
	echo "Riskchanges database created"
fi

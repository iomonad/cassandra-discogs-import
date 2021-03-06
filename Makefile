KEYSPACE = discogs
MIGRATE_FILE = schemas.cql

migrate:
	cqlsh -e "CREATE KEYSPACE IF NOT EXISTS discogs WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };"
	cqlsh -k ${KEYSPACE} -f ${MIGRATE_FILE}

clean:
	cqlsh -e "DROP KEYSPACE IF EXISTS discogs;"

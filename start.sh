DBNAME=mirrorbrain
DBUSER=mirrorbrain
DBHOST=db
PSQL_ARGS="-h $DBHOST -U postgres"
PSQL_MB_ARGS="-h $DBHOST  -U $DBUSER $DBNAME"
MBSQL_DIR=/usr/share/doc/mirrorbrain/sql

sleep 1

if ! psql -lqt $PSQL_ARGS | cut -d \| -f 1 | grep -qw $DBNAME; then
  createuser $PSQL_ARGS -s $DBUSER 
  createdb  $PSQL_ARGS -O $DBUSER $DBNAME 
  createlang  $PSQL_ARGS plpgsql $DBNAME
  gunzip -c $MBSQL_DIR/schema-postgresql.sql.gz | psql $PSQL_MB_ARGS
  gunzip -c $MBSQL_DIR/initialdata-postgresql.sql.gz | psql $PSQL_MB_ARGS
fi

httpd-foreground

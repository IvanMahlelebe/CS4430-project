#!/bin/bash

create_random_function() {
  echo "Creating random function..."
  COORDINATOR_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dm-coordinator)
  psql -h "$COORDINATOR_IP" -p 5432 -U dm-user -d datamine_db <<-EOSQL
    CREATE OR REPLACE FUNCTION generate_random_integer()
    RETURNS INTEGER AS \$\$
    BEGIN
      RETURN floor((random() * 5) + 8)::int;
    END;
    \$\$ LANGUAGE plpgsql;
EOSQL
}

update_table_column() {
  table=$1
  column=$2

  echo "Updating column $column in table $table..."
  COORDINATOR_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dm-coordinator)
  psql -h "$COORDINATOR_IP" -p 5432 -U dm-user -d datamine_db <<-EOSQL
    BEGIN;
    UPDATE $table
    SET $column = FLOOR(RANDOM() * 5 + 8)::int
    FROM (
      SELECT performanceid
      FROM $table
    ) AS subquery
    WHERE $table.performanceid = subquery.performanceid;
    COMMIT;
EOSQL
}

# Create random function
create_random_function

# Update table column
update_table_column "performance" "grade"

echo "Column update completed!"

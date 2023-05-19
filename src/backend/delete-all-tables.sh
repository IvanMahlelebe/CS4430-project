#!/bin/bash

: '
This is a script to DELETE ALL tables inside our datamine_db(database)

The below command might require an installation of psql client. One way
to doing this is through the command:
`sudo apt-get install postgresql-client`

To identify the host(coordinator node), its IP address was used instead
and it was found using the command:
`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dm-coordinator`

Other inputs such as psql username and database name can be found inside the docker-compose
file included in the current directory.
'

COORDINATOR_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dm-coordinator)
psql -h "$COORDINATOR_IP" -p 5432 -U dm-user -d datamine_db << EOF

  SELECT set_citus_shard_count(0);
  DROP SCHEMA public CASCADE;
  CREATE SCHEMA public;
  SELECT set_citus_shard_count(64);

EOF
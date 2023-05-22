#!/bin/bash

insert_data() {
  file=$1
  table=$2

  echo "Inserting data into table $table..."
  COORDINATOR_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dm-coordinator)
  psql -h "$COORDINATOR_IP" -p 5432 -U dm-user -d datamine_db <<-EOSQL
    BEGIN;
    \copy $table FROM '$file' DELIMITER ',' CSV HEADER;
    COMMIT;
EOSQL

  if [[ $? -ne 0 ]]; then
    echo "An error occurred during data insertion. Rolling back changes..."
    psql -h "$COORDINATOR_IP" -p 5432 -U dm-user -d datamine_db <<-EOF
      ROLLBACK;
      DELETE FROM student_demography;
      DELETE FROM performance;
      DELETE FROM support;
      DELETE FROM school_student;
      DELETE FROM school_educator;
      DELETE FROM student;
      DELETE FROM educator;
      DELETE FROM school;
EOF
    exit 1
  fi
}

# Insert data into tables
insert_data "school_data.csv" "school"
insert_data "educator_data.csv" "educator"
insert_data "student_data.csv" "student"
insert_data "school_educator_data.csv" "school_educator"
insert_data "school_student_data.csv" "school_student"
insert_data "support_data.csv" "support"
insert_data "performance_data.csv" "performance"
insert_data "student_demography_data.csv" "student_demography"

echo "Data insertion completed!"

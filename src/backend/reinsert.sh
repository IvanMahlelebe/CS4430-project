#!/bin/bash

insert_school_student_data() {
  file=$1
  table=$2
  temp_table="${table}_temp"

  echo "Inserting data into table $table..."
  COORDINATOR_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dm-coordinator)
  psql -h "$COORDINATOR_IP" -p 5432 -U dm-user -d datamine_db <<-EOSQL
    BEGIN;
    -- Create temporary table
    CREATE TEMP TABLE $temp_table (LIKE $table INCLUDING CONSTRAINTS);

    -- Insert data into temporary table
    \copy $temp_table FROM '$file' DELIMITER ',' CSV HEADER;

    -- Insert data from temporary table into target table, excluding rows with duplicate primary key values
    INSERT INTO $table
    SELECT *
    FROM $temp_table
    WHERE NOT EXISTS (
      SELECT 1
      FROM (SELECT * FROM $table) AS t
      WHERE (t.schoolID, t.regionID, t.studentID) = ($temp_table.schoolID, $temp_table.regionID, $temp_table.studentID)
    );

    COMMIT;
EOSQL
}

insert_school_educator_data() {
  file=$1
  table=$2
  temp_table="${table}_temp"

  echo "Inserting data into table $table..."
  COORDINATOR_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dm-coordinator)
  psql -h "$COORDINATOR_IP" -p 5432 -U dm-user -d datamine_db <<-EOSQL
    BEGIN;
    -- Create temporary table
    CREATE TEMP TABLE $temp_table (LIKE $table INCLUDING CONSTRAINTS);

    -- Insert data into temporary table
    \copy $temp_table FROM '$file' DELIMITER ',' CSV HEADER;

    -- Insert data from temporary table into target table, excluding rows with duplicate primary key values
    INSERT INTO $table
    SELECT *
    FROM $temp_table
    WHERE NOT EXISTS (
      SELECT 1
      FROM (SELECT * FROM $table) AS t
      WHERE (t.educatorID, t.schoolID, t.regionID, t.transfer_date) = ($temp_table.educatorID, $temp_table.schoolID, $temp_table.regionID, $temp_table.transfer_date)
    );

    COMMIT;
EOSQL
}

# Insert data into tables
insert_school_educator_data "school_educator_data.csv" "school_educator"
insert_school_student_data "school_student_data.csv" "school_student"

echo "Data insertion completed!"

#!/bin/bash

# Define function to perform cleanup actions
cleanup() {
    echo "RIVERTING PROGRESS..."
    docker-compose down # Remove containers
    docker network rm my-citus-net # Remove the network
    exit 1
}

# Set trap to catch errors and call cleanup function
trap 'echo "Error occurred!"; cleanup' ERR

docker network create datamine-network # Create network
docker-compose up -d # Start containers

# Wait 3mins for containers to start up
sleep 180

# CREATE, CONNECT TO & CREATE TABLES IN DATABASES

# Coordinator
docker exec -it dm-coordinator psql -U datamine-user -c "create database datamine_db;"
docker exec -it citus-coordinator psql -U datamine-user -d datamine-network -c "

CREATE TABLE district (
  d_id integer,
  d_name text,
  d_region text,
  PRIMARY KEY (d_id)
);

CREATE TABLE school (
  school_id integer,
  school_name text,
  school_location text,
  d_id integer REFERENCES district(d_id),
  PRIMARY KEY (school_id)
);

CREATE TABLE educator (
  ed_id interger,
  ed_name text,
  ed_position text, 
  ed_subject text,
  ed_qualification text,
  ed_DOB text,
  ed_sex text,
  school_id integer REFERENCES school(school_id),
  PRIMARY KEY (ed_id)
);

CREATE TABLE school_educator (
  school_id integer REFERENCES school(school_id),
  ed_id integer REFERENCES educator(ed_id),
  transfer_date text,
);

CREATE TABLE school_student (
  school_id integer REFERENCES school(school_id),
  student_id integer REFERENCES student(student_id),
  transfer_date text,
);

CREATE TABLE student (
  student_id integer,
  student_name text,
  student_lastname text
  PRIMARY KEY (student_id)
);

CREATE TABLE performance (
  p_id integer,
  p_grade integer,
  p_average_score float,
  student_id integer REFERENCES student(student_id)
);

CREATE TABLE student_dem (
  dem_id integer,
  dem_gender text,
  dem_disability text,
  dem social_status text,
  demo_econ_status text,
  student_id integer REFERENCES student(student_id)
);

CREATE TABLE resource (
  res_id integer,
  res_name text,
  res_type text,
  res_desc text,
  res_location text,
  school_id integer REFERENCES school(school_id)
  PRIMARY KEY (res_id)
);

SELECT create_distributed_table('district', 'd_region');
SELECT create_distributed_table('school', 'd_id');
SELECT create_distributed_table('educator', 'school_id');
SELECT create_distributed_table('school_educator', 'school_id');
SELECT create_distributed_table('school_student', 'school_id');
SELECT create_distributed_table('student', 'student_id');
SELECT create_distributed_table('performance', 'student_id');
SELECT create_distributed_table('student_dem', 'student_id');
SELECT create_distributed_table('resource', 'school_id');


"

# Insert data from Excel files
docker cp districts.xlsx dm-coordinator:/tmp/districts.xlsx
docker exec -it dm-coordinator sh -c "pgfutter csv /tmp/customers.xlsx | psql -U datamine-user datamine-db -c 'COPY district FROM STDIN WITH (FORMAT CSV, HEADER TRUE)'"

sleep 30

docker cp schools.xlsx dm-coordinator:/tmp/schools.xlsx
docker exec -it dm-coordinator sh -c "pgfutter csv /tmp/schools.xlsx | psql -U datamine-user datamine-db -c 'COPY school FROM STDIN WITH (FORMAT CSV, HEADER TRUE)'"

sleep 30

docker cp educators.xlsx dm-coordinator:/tmp/educators.xlsx
docker exec -it dm-coordinator sh -c "pgfutter csv /tmp/educators.xlsx | psql -U datamine-user datamine-db -c 'COPY educator FROM STDIN WITH (FORMAT CSV, HEADER TRUE)'"

sleep 30

docker cp school_educators.xlsx dm-coordinator:/tmp/school_educators.xlsx
docker exec -it dm-coordinator sh -c "pgfutter csv /tmp/school_educators.xlsx | psql -U datamine-user datamine-db -c 'COPY school_educator FROM STDIN WITH (FORMAT CSV, HEADER TRUE)'"

sleep 30

docker cp school_students.xlsx dm-coordinator:/tmp/school_students.xlsx
docker exec -it dm-coordinator sh -c "pgfutter csv /tmp/school_students.xlsx | psql -U datamine-user datamine-db -c 'COPY school_student FROM STDIN WITH (FORMAT CSV, HEADER TRUE)'"

sleep 30

docker cp students.xlsx dm-coordinator:/tmp/students.xlsx
docker exec -it dm-coordinator sh -c "pgfutter csv /tmp/school_students.xlsx | psql -U datamine-user datamine-db -c 'COPY student FROM STDIN WITH (FORMAT CSV, HEADER TRUE)'"

# Display inserted data(Testing)
docker exec -it dm-coordinator psql -U datamine-user -d datamine-db -c "SELECT * FROM students;"

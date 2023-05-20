#!/bin/bash

: '
This is a script to create tables inside our datamine_db(database)

The below command might require an installation of psql client. An
alternative to doing this is:
`sudo apt-get install postgresql-client`

To identify the host (coordinator node), its IP address was used instead
and it was found using the command:
`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dm-coordinator`

Other inputs such as psql username and database name can be found inside the docker-compose
file included in the current directory.
'

# Store the current error handling settings
set -e

# Define a function to handle errors and perform rollback
handle_error() {
  echo "Error occurred. Rolling back changes..."
  
  # Run the rollback commands
  psql -h "$COORDINATOR_IP" -p 5432 -U dm-user -d datamine_db <<EOF
    -- Add rollback commands here
    DROP TABLE IF EXISTS region CASCADE;
    DROP TABLE IF EXISTS school CASCADE;
    DROP TABLE IF EXISTS educator CASCADE;
    DROP TABLE IF EXISTS student CASCADE;
    DROP TABLE IF EXISTS school_educator CASCADE;
    DROP TABLE IF EXISTS school_student CASCADE;
    DROP TABLE IF EXISTS support CASCADE;
    DROP TABLE IF EXISTS performance CASCADE;
    DROP TABLE IF EXISTS student_demography CASCADE;
EOF
  
  exit 1
}

# Trap errors and call the error handling function
trap 'handle_error' ERR

# Get the coordinator IP
COORDINATOR_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dm-coordinator)
psql -h "$COORDINATOR_IP" -p 5432 -U dm-user -d datamine_db << EOF
START TRANSACTION;

CREATE TABLE region (
  regionID SERIAL PRIMARY KEY,
  rName TEXT,
);


CREATE TABLE student (
  studentID SERIAL,
  studentName TEXT,
  studentLastName TEXT,
  regionID INT,

  PRIMARY KEY (studentID, regionID),
  FOREIGN KEY (regionID) REFERENCES region (regionID)
);


CREATE TABLE school (
  schoolID SERIAL,
  regionID INT,
  schoolName TEXT,

  PRIMARY KEY (schoolID, regionID),
  FOREIGN KEY (regionID) REFERENCES region (regionID)
);


CREATE TABLE educator (
  educatorID SERIAL,
  regionID INT,
  eName TEXT,
  position TEXT,
  subject TEXT,
  qualification TEXT,
  birthDate DATE,
  sex TEXT,
  schoolID INT,

  PRIMARY KEY (educatorID, regionID),
  FOREIGN KEY (schoolID, regionID) REFERENCES school (schoolID, regionID)
);


CREATE TABLE school_educator (
  educatorID INT,
  schoolID INT,
  regionID INT,
  transfer_date DATE,

  PRIMARY KEY (schoolID, educatorID, regionID),

  FOREIGN KEY (schoolID, regionID)
  REFERENCES school (schoolID, regionID),

  FOREIGN KEY (educatorID, regionID)
  REFERENCES educator (educatorID, regionID)
);


CREATE TABLE school_student (
  schoolID INT,
  regionID INT,
  studentID INT,
  transferDate DATE,

  PRIMARY KEY (schoolID, regionID, studentID),
  
  FOREIGN KEY (schoolID, regionID)
  REFERENCES school (schoolID, regionID),

  FOREIGN KEY (studentID, regionID)
  REFERENCES student (studentID, regionID)
);


CREATE TABLE support (
  supportID SERIAL,
  regionID INT,
  type TEXT,
  days_duration INT,
  outcome TEXT,
  schoolID INT,

  PRIMARY KEY (supportID, regionID),
  
  FOREIGN KEY (schoolID, regionID)
  REFERENCES school (schoolID, regionID)
);


CREATE TABLE performance (
  performanceID SERIAL,
  regionID INT,
  grade INT,
  avg_score FLOAT,
  studentID INT,

  PRIMARY KEY (performanceID, regionID),

  FOREIGN KEY (studentID, regionID)
  REFERENCES student (studentID, regionID)
);


CREATE TABLE student_demography (
  demoID INT,
  regionID INT,
  studentID INT,
  gender TEXT,
  race TEXT,
  disability TEXT,
  socialStatus TEXT,
  economicStatus TEXT,

  PRIMARY KEY (demoID, regionID),

  FOREIGN KEY (studentID, regionID)
  REFERENCES student (studentID, regionID)
);


COMMIT;
EOF

echo "Done!"

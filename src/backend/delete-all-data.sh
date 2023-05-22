COORDINATOR_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dm-coordinator)
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


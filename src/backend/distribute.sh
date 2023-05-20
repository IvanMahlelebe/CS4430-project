
COORDINATOR_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dm-coordinator)
psql -h "$COORDINATOR_IP" -p 5432 -U dm-user -d datamine_db << EOF

    CREATE TABLE region_mapping (
        regionID INT PRIMARY KEY,
        node_name TEXT
    );

    INSERT INTO region_mapping (regionID, node_name)
    VALUES
        (1, 'dm-mohale'),
        (2, 'dm-leribe'),
        (3, 'dm-qacha'),
        (4, 'dm-maseru');

    CREATE OR REPLACE FUNCTION region_mapping_function(regionID INT)
    RETURNS TEXT AS $$
    BEGIN
        RETURN (
            SELECT node_name
            FROM region_mapping
            WHERE region_mapping.regionID = regionID
        );
    END;
    $$ LANGUAGE plpgsql;

    CREATE EXTENSION IF NOT EXISTS citus;

    SELECT create_distributed_table('region', 'regionID');
    SELECT create_distributed_table('student', 'regionID');
    SELECT create_distributed_table('school', 'regionid');
    SELECT create_distributed_table('educator', 'regionid');
    SELECT create_distributed_table('school_educator', 'regionid');
    SELECT create_distributed_table('school_student', 'regionid');
    SELECT create_distributed_table('support', 'regionid');
    SELECT create_distributed_table('performance', 'regionid');
    SELECT create_distributed_table('student_demography', 'regionid');
EOF

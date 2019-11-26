-- concurrently create roles
CREATE OR REPLACE FUNCTION create_role (TEXT, TEXT) RETURNS void AS $$
  DECLARE
    role_name ALIAS FOR $1;
    options ALIAS FOR $2;
  BEGIN
    IF options ISNULL THEN
      options := 'NOCREATEDB NOCREATEROLE NOINHERIT NOLOGIN';
    END IF;  
    EXECUTE 'CREATE ROLE ' || role_name || ' ' || options;
    EXCEPTION WHEN duplicate_object THEN 
      RAISE NOTICE 'role already exists' ;
  END;
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION init_schema (TEXT) RETURNS TEXT AS $$
  DECLARE
    sch_name ALIAS FOR $1;
    db_name TEXT;
    sch_role_ro TEXT;
    sch_role_rw TEXT;
  BEGIN

    db_name := current_database();

    IF EXISTS(
      SELECT
      FROM pg_authid AS a JOIN pg_database AS d ON (d.datdba = a.oid)
      WHERE d.datname = current_database()
      AND a.rolname != 'dbo')
    THEN
      RAISE NOTICE 'default roles not created, initializing DB';

      PERFORM create_role('ro', 'NOCREATEDB NOCREATEROLE NOINHERIT NOLOGIN');
      PERFORM create_role('rw', 'NOCREATEDB NOCREATEROLE NOINHERIT NOLOGIN');
      PERFORM create_role('dba', 'NOCREATEDB NOCREATEROLE NOINHERIT NOLOGIN');
      PERFORM create_role('dbo', 'CREATEDB CREATEROLE NOINHERIT NOLOGIN');
      PERFORM create_role('dbmaster', 'SUPERUSER');
      GRANT dbo TO dba;

      -- set create, connect, owner (db)
      EXECUTE 'REVOKE ALL ON DATABASE ' || db_name || ' FROM PUBLIC, ro, rw, dba, dbo';
      EXECUTE 'GRANT CONNECT ON DATABASE ' || db_name || ' TO PUBLIC, ro, rw, dba';
      EXECUTE 'GRANT CREATE, CONNECT, TEMP ON DATABASE ' || db_name || ' TO dbo';
      EXECUTE 'ALTER DATABASE ' || db_name || ' OWNER TO dbo';

      -- set default permissions on schemas
      EXECUTE 'ALTER DEFAULT PRIVILEGES REVOKE ALL ON SCHEMAS FROM PUBLIC, ro, rw, dba, dbo';
      EXECUTE 'ALTER DEFAULT PRIVILEGES GRANT USAGE ON SCHEMAS TO ro, rw, dba';
      EXECUTE 'ALTER DEFAULT PRIVILEGES GRANT CREATE, USAGE ON SCHEMAS TO dbo';

      -- set default permissions on tables
      EXECUTE 'ALTER DEFAULT PRIVILEGES REVOKE ALL ON TABLES FROM PUBLIC, ro, rw, dba, dbo';
      EXECUTE 'ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO ro';
      EXECUTE 'ALTER DEFAULT PRIVILEGES GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON TABLES TO rw, dba, dbo';

      -- set default privileges on sequences
      EXECUTE 'ALTER DEFAULT PRIVILEGES REVOKE ALL ON SEQUENCES FROM PUBLIC, ro, rw, dba, dbo';
      EXECUTE 'ALTER DEFAULT PRIVILEGES GRANT SELECT ON SEQUENCES TO ro';
      EXECUTE 'ALTER DEFAULT PRIVILEGES GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO rw, dba, dbo';

      -- set default privileges on functions
      EXECUTE 'ALTER DEFAULT PRIVILEGES REVOKE ALL ON FUNCTIONS FROM PUBLIC, ro, rw, dba, dbo';
      EXECUTE 'ALTER DEFAULT PRIVILEGES GRANT EXECUTE ON FUNCTIONS TO rw, dba, dbo';

      -- set default privileges on types
      EXECUTE 'ALTER DEFAULT PRIVILEGES REVOKE ALL ON TYPES FROM ro, rw, dba, dbo';
      EXECUTE 'ALTER DEFAULT PRIVILEGES GRANT USAGE ON TYPES TO ro, rw, dba, dbo';

    END IF; 

    IF sch_name ISNULL THEN
      sch_name := 'public';
    END IF;

    EXECUTE 'CREATE SCHEMA IF NOT EXISTS ' || sch_name;
    EXECUTE 'ALTER SCHEMA ' || sch_name || ' OWNER TO dbo';

    -- set privileges to global users (schema)

    -- set privileges on schema (schema)
    EXECUTE 'REVOKE ALL ON SCHEMA ' || sch_name || ' FROM PUBLIC, ro, rw, dba, dbo';
    EXECUTE 'GRANT USAGE ON SCHEMA ' || sch_name || ' TO ro, rw, dba';
    EXECUTE 'GRANT CREATE, USAGE ON SCHEMA ' || sch_name || ' TO dbo';

    -- set privileges on tables (schema)
    EXECUTE 'REVOKE ALL ON ALL TABLES IN SCHEMA ' || sch_name || ' FROM ro, rw, dba, dbo';
    EXECUTE 'GRANT SELECT ON ALL TABLES IN SCHEMA ' || sch_name || ' TO ro';
    EXECUTE 'GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA ' || sch_name || ' TO rw, dba, dbo';

    -- set privileges on sequences (schema)
    EXECUTE 'REVOKE ALL ON ALL SEQUENCES IN SCHEMA ' || sch_name || ' FROM PUBLIC, ro, rw, dba, dbo';
    EXECUTE 'GRANT SELECT ON ALL SEQUENCES IN SCHEMA ' || sch_name || ' TO ro';
    EXECUTE 'GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA ' || sch_name || ' TO rw, dba, dbo';

    -- set privileges on functions (schema)
    EXECUTE 'REVOKE ALL ON ALL FUNCTIONS IN SCHEMA ' || sch_name || ' FROM PUBLIC, ro, rw, dba, dbo';
    EXECUTE 'GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA ' || sch_name || ' TO rw, dba, dbo';

    -- set privileges to specific users (schema)
 
    sch_role_ro := db_name || '_' || sch_name || '_ro';
    sch_role_rw := db_name || '_' || sch_name || '_rw';

    PERFORM create_role(sch_role_ro, 'NOCREATEDB NOCREATEROLE NOINHERIT NOLOGIN');
    PERFORM create_role(sch_role_rw, 'NOCREATEDB NOCREATEROLE NOINHERIT NOLOGIN');

    -- set create, connect (db)
    EXECUTE 'REVOKE ALL ON DATABASE ' || db_name || ' FROM ' || sch_role_ro || ', ' || sch_role_rw;
    EXECUTE 'GRANT CONNECT ON DATABASE ' || db_name || ' TO ' || sch_role_ro || ', ' || sch_role_rw;

    -- set default permissions on schemas (schema)
    EXECUTE 'ALTER DEFAULT PRIVILEGES REVOKE ALL ON SCHEMAS FROM ' || sch_role_ro || ', ' || sch_role_rw;

    -- set default permissions on tables (schema)
    EXECUTE 'ALTER DEFAULT PRIVILEGES REVOKE ALL ON TABLES FROM ' || sch_role_ro || ', ' || sch_role_rw;
    EXECUTE 'ALTER DEFAULT PRIVILEGES IN SCHEMA ' || sch_name || ' GRANT SELECT ON TABLES TO ' || sch_role_ro;
    EXECUTE 'ALTER DEFAULT PRIVILEGES IN SCHEMA ' || sch_name || ' GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON TABLES TO ' || sch_role_rw;

    -- set default privileges on sequences (schema)
    EXECUTE 'ALTER DEFAULT PRIVILEGES REVOKE ALL ON SEQUENCES FROM ' || sch_role_ro || ', ' || sch_role_rw;
    EXECUTE 'ALTER DEFAULT PRIVILEGES IN SCHEMA ' || sch_name || ' GRANT SELECT ON SEQUENCES TO ' || sch_role_ro;
    EXECUTE 'ALTER DEFAULT PRIVILEGES IN SCHEMA ' || sch_name || ' GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO ' || sch_role_rw;

    -- set default privileges on functions (schema)
    EXECUTE 'ALTER DEFAULT PRIVILEGES REVOKE ALL ON FUNCTIONS FROM ' || sch_role_ro || ', ' || sch_role_rw;
    EXECUTE 'ALTER DEFAULT PRIVILEGES IN SCHEMA ' || sch_name || ' GRANT EXECUTE ON FUNCTIONS TO ' || sch_role_rw;

    -- set default privileges on types (schema)
    EXECUTE 'ALTER DEFAULT PRIVILEGES REVOKE ALL ON TYPES FROM ' || sch_role_ro || ', ' || sch_role_rw;
    EXECUTE 'ALTER DEFAULT PRIVILEGES IN SCHEMA ' || sch_name || ' GRANT USAGE ON TYPES TO ' || sch_role_ro || ', ' || sch_role_rw;

    -- set privileges on schema (schema)
    EXECUTE 'REVOKE ALL ON SCHEMA ' || sch_name || ' FROM ' || sch_role_ro || ', ' || sch_role_rw;
    EXECUTE 'GRANT USAGE ON SCHEMA ' || sch_name || ' TO ' || sch_role_ro || ', ' || sch_role_rw;

    -- set privileges on tables (schema)
    EXECUTE 'REVOKE ALL ON ALL TABLES IN SCHEMA ' || sch_name || ' FROM ' || sch_role_ro || ', ' || sch_role_rw;
    EXECUTE 'GRANT SELECT ON ALL TABLES IN SCHEMA ' || sch_name || ' TO ' || sch_role_ro;
    EXECUTE 'GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA ' || sch_name || ' TO ' || sch_role_rw;

    -- set privileges on sequences (schema)
    EXECUTE 'REVOKE ALL ON ALL SEQUENCES IN SCHEMA ' || sch_name || ' FROM ' || sch_role_ro || ', ' || sch_role_rw;
    EXECUTE 'GRANT SELECT ON ALL SEQUENCES IN SCHEMA ' || sch_name || ' TO ' || sch_role_ro;
    EXECUTE 'GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA ' || sch_name || ' TO ' || sch_role_rw;

    -- set privileges on functions (schema)
    EXECUTE 'REVOKE ALL ON ALL FUNCTIONS IN SCHEMA ' || sch_name || ' FROM ' || sch_role_ro || ', ' || sch_role_rw;
    EXECUTE 'GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA ' || sch_name || ' TO ' || sch_role_rw;
    
    RETURN sch_name;
  END;
$$ LANGUAGE 'plpgsql';

SELECT init_schema('public');

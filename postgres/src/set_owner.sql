
CREATE OR REPLACE FUNCTION create_default_role (TEXT) RETURNS void AS $$
    DECLARE
        role_name ALIAS FOR $1;
    BEGIN
        EXECUTE 'CREATE ROLE '|| role_name ||' NOCREATEDB NOCREATEROLE NOINHERIT NOLOGIN;';
        EXCEPTION WHEN duplicate_object THEN 
            RAISE NOTICE 'role already exists, not re-creating' ;
    END;
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION init_schema (TEXT) RETURNS TEXT AS $$
    DECLARE
        sch_name ALIAS FOR $1;
        db_name TEXT;
    BEGIN
        db_name := current_database();
        IF sch_name ISNULL THEN
            sch_name := 'public';
        END IF;    
        EXECUTE 'CREATE SCHEMA  IF NOT EXISTS ' || sch_name || ';';
        
        PERFORM create_default_role('ro');
        PERFORM create_default_role('rw');
        PERFORM create_default_role('dba');
        PERFORM create_default_role('dbo');
        GRANT dbo TO dba;
        
        
        PERFORM create_default_role('mytest');
        
        -- set create, connect, owner (db:postgres)
        EXECUTE 'REVOKE CREATE, CONNECT, TEMP ON DATABASE ' || db_name || ' FROM PUBLIC, ro, rw, dba, dbo;';
        EXECUTE 'GRANT CONNECT ON DATABASE ' || db_name || ' TO PUBLIC, ro, rw, dba;';
        EXECUTE 'GRANT CREATE, CONNECT, TEMP ON DATABASE ' || db_name || ' TO dbo;';
        EXECUTE 'ALTER SCHEMA ' || sch_name || ' OWNER TO dbo;';
        EXECUTE 'ALTER DATABASE ' || db_name || ' OWNER TO dbo;';

        -- set default permissions on schemas
        ALTER DEFAULT PRIVILEGES REVOKE USAGE, CREATE ON SCHEMAS FROM PUBLIC, ro, rw, dba, dbo;
        ALTER DEFAULT PRIVILEGES GRANT USAGE ON SCHEMAS TO ro, rw, dba;
        ALTER DEFAULT PRIVILEGES GRANT CREATE, USAGE ON SCHEMAS TO dbo;

        -- set default permissions on tables
        ALTER DEFAULT PRIVILEGES REVOKE ALL ON TABLES FROM PUBLIC, ro, rw, dba, dbo;
        ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO ro;
        ALTER DEFAULT PRIVILEGES GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO rw;
        ALTER DEFAULT PRIVILEGES GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON TABLES TO dba, dbo;

        -- set default privileges for sequences
        ALTER DEFAULT PRIVILEGES REVOKE ALL ON SEQUENCES FROM PUBLIC, ro;
        ALTER DEFAULT PRIVILEGES GRANT SELECT ON SEQUENCES TO ro;
        ALTER DEFAULT PRIVILEGES GRANT USAGE, SELECT ON SEQUENCES TO rw;
        ALTER DEFAULT PRIVILEGES GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO dba, dbo;

        -- set default privileges for functions
        ALTER DEFAULT PRIVILEGES REVOKE ALL ON FUNCTIONS FROM PUBLIC, ro;
        ALTER DEFAULT PRIVILEGES GRANT EXECUTE ON FUNCTIONS TO rw, dba, dbo;

        -- set default privileges for types
        ALTER DEFAULT PRIVILEGES REVOKE ALL ON TYPES FROM ro, rw, dba, dbo;
        ALTER DEFAULT PRIVILEGES GRANT USAGE ON TYPES TO ro, rw, dba, dbo;

        --- set privileges on schema (schema:public)
        EXECUTE 'REVOKE ALL ON SCHEMA ' || sch_name || ' FROM PUBLIC, ro, rw, dba, dbo;';
        EXECUTE 'GRANT USAGE ON SCHEMA ' || sch_name || ' TO ro, rw, dba;';
        EXECUTE 'GRANT CREATE, USAGE ON SCHEMA ' || sch_name || ' TO dbo;';

        --- set privileges on tables (schema:public)
        EXECUTE 'REVOKE ALL ON ALL TABLES IN SCHEMA ' || sch_name || ' FROM ro, rw, dba, dbo;';
        EXECUTE 'GRANT SELECT ON ALL TABLES IN SCHEMA ' || sch_name || ' TO ro;';
        EXECUTE 'GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA ' || sch_name || ' TO rw;';
        EXECUTE 'GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA ' || sch_name || ' TO dba, dbo;';

        --- set privileges on sequences (schema:public)
        EXECUTE 'REVOKE ALL ON ALL SEQUENCES IN SCHEMA ' || sch_name || ' FROM PUBLIC, ro, rw, dba, dbo;';
        EXECUTE 'GRANT SELECT ON ALL SEQUENCES IN SCHEMA ' || sch_name || ' TO ro;';
        EXECUTE 'GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA ' || sch_name || ' TO rw;';
        EXECUTE 'GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA ' || sch_name || ' TO dba, dbo;';

        --- set privileges on functions (schema:public)
        EXECUTE 'REVOKE ALL ON ALL FUNCTIONS IN SCHEMA ' || sch_name || ' FROM PUBLIC, ro, rw, dba, dbo;';
        EXECUTE 'GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA ' || sch_name || ' TO rw, dba, dbo;';
        
        RETURN sch_name;
    END;
$$ LANGUAGE 'plpgsql';



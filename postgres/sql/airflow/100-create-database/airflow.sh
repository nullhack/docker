psql -v ON_ERROR_STOP=1 --username="${POSTGRES_USER:?POSTGRES_USER}" <<-EOQUERY
    CREATE DATABASE airflow;
EOQUERY

psql -v ON_ERROR_STOP=1 --dbname=airflow --username="${POSTGRES_USER:?POSTGRES_USER}" <<-EOQUERY
    CREATE ROLE airflow_readonly;
    GRANT CONNECT ON DATABASE airflow TO airflow_readonly;
    GRANT USAGE ON SCHEMA public TO airflow_readonly;
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO airflow_readonly;
EOQUERY

psql -v ON_ERROR_STOP=1 --dbname=airflow --username="${POSTGRES_USER:?POSTGRES_USER}" <<-EOQUERY
    CREATE ROLE airflow_readwrite;
    GRANT CONNECT ON DATABASE airflow TO airflow_readwrite;
    GRANT USAGE ON SCHEMA public TO airflow_readwrite;
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO airflow_readwrite;
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE ON SEQUENCES TO airflow_readwrite;
EOQUERY

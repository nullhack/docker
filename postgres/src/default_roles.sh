# update user
psql -v ON_ERROR_STOP=0 --dbname=${POSTGRES_DB:-postgres} --username=${POSTGRES_USER:-postgres} <<-EOQUERY
    REVOKE CREATE ON SCHEMA public FROM public
    ALTER USER ${POSTGRES_USER:-postgres} WITH ENCRYPTED PASSWORD '${POSTGRES_PASSWORD:-postgres}';
    GRANT ALL PRIVILEGES ON DATABASE ${POSTGRES_DB:-postgres} TO ${POSTGRES_USER:-postgres};
EOQUERY

# create readwrite role
psql -v ON_ERROR_STOP=0 --dbname=${POSTGRES_DB:-postgres} --username=${POSTGRES_USER:-postgres} <<-EOQUERY
    CREATE ROLE readwrite;
    GRANT CONNECT ON DATABASE ${POSTGRES_DB:-postgres} TO readwrite;
    GRANT USAGE ON SCHEMA public TO readwrite;
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO readwrite;
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE ON SEQUENCES TO readwrite;
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES IN SCHEMA public TO readwrite;
    GRANT USAGE ON SEQUENCES IN SCHEMA public TO readwrite;
EOQUERY

# create readwrite user
psql -v ON_ERROR_STOP=0 --dbname=${POSTGRES_DB:-postgres} --username=${POSTGRES_USER:-postgres} <<-EOQUERY
    CREATE USER ${POSTGRES_USER:-postgres}_readwrite WITH ENCRYPTED PASSWORD '${POSTGRES_PASSWORD:-postgres}';
    GRANT readwrite TO ${POSTGRES_USER:-postgres}_readwrite;
EOQUERY

# create readonly role
psql -v ON_ERROR_STOP=0 --dbname=${POSTGRES_DB:-postgres} --username=${POSTGRES_USER:-postgres} <<-EOQUERY
    CREATE ROLE readonly;
    GRANT CONNECT ON DATABASE ${POSTGRES_DB:-postgres} TO readonly;
    GRANT USAGE ON SCHEMA public TO readonly;
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO readonly;
    GRANT SELECT ON TABLES IN SCHEMA public TO readonly;
EOQUERY

# create readonly user
psql -v ON_ERROR_STOP=0 --dbname=${POSTGRES_DB:-postgres} --username=${POSTGRES_USER:-postgres} <<-EOQUERY
    CREATE USER ${POSTGRES_USER:-postgres}_readonly WITH ENCRYPTED PASSWORD '${POSTGRES_PASSWORD:-postgres}';
    GRANT readonly TO ${POSTGRES_USER:-postgres}_readonly;
EOQUERY

# create viewonly role
psql -v ON_ERROR_STOP=0 --dbname=${POSTGRES_DB:-postgres} --username=${POSTGRES_USER:-postgres} <<-EOQUERY
    CREATE ROLE viewonly;
    CREATE SCHEMA views;
    GRANT CONNECT ON DATABASE ${POSTGRES_DB:-postgres} TO viewonly;
    GRANT USAGE ON SCHEMA views TO viewonly;
    ALTER DEFAULT PRIVILEGES IN SCHEMA views GRANT SELECT ON TABLES TO viewonly;
    GRANT SELECT ON TABLES IN SCHEMA public TO readonly;
EOQUERY

# create viewonly user
psql -v ON_ERROR_STOP=0 --dbname=${POSTGRES_DB:-postgres} --username=${POSTGRES_USER:-postgres} <<-EOQUERY
    CREATE USER ${POSTGRES_USER:-postgres}_viewonly WITH ENCRYPTED PASSWORD '${POSTGRES_PASSWORD:-postgres}';
    ALTER USER ${POSTGRES_USER:-postgres}_viewonly set search_path = 'views';
    GRANT viewonly TO ${POSTGRES_USER:-postgres}_viewonly;
EOQUERY

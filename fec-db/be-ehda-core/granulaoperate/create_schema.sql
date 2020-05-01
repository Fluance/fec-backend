\c postgres;

CREATE DATABASE granulaoperate OWNER fluance;

REVOKE ALL ON DATABASE granulaoperate FROM PUBLIC;

\c granulaoperate;

CREATE SCHEMA IF NOT EXISTS ehealth AUTHORIZATION fluance;

ALTER DATABASE granulaoperate SET search_path TO ehealth;

REVOKE ALL ON SCHEMA ehealth FROM PUBLIC;

GRANT CONNECT ON DATABASE granulaoperate TO dbinput;
GRANT TEMPORARY ON DATABASE granulaoperate TO dbinput;
GRANT USAGE ON SCHEMA ehealth TO dbinput;
GRANT CONNECT ON DATABASE granulaoperate TO leech;
GRANT USAGE ON SCHEMA ehealth TO leech;

ALTER DEFAULT PRIVILEGES IN SCHEMA ehealth GRANT SELECT,INSERT,UPDATE,DELETE ON TABLES TO dbinput;
ALTER DEFAULT PRIVILEGES IN SCHEMA ehealth GRANT USAGE,SELECT ON SEQUENCES TO dbinput;
ALTER DEFAULT PRIVILEGES IN SCHEMA ehealth GRANT EXECUTE ON FUNCTIONS TO dbinput;
ALTER DEFAULT PRIVILEGES IN SCHEMA ehealth GRANT SELECT ON TABLES TO leech;
ALTER DEFAULT PRIVILEGES REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC;
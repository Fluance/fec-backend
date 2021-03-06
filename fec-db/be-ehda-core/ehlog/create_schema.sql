\c postgres;

CREATE DATABASE ehlog OWNER fluance;

REVOKE ALL ON DATABASE ehlog FROM PUBLIC;

\c ehlog;

CREATE SCHEMA IF NOT EXISTS ehealth AUTHORIZATION fluance;

SET search_path TO ehealth;

REVOKE ALL ON SCHEMA ehealth FROM PUBLIC;

GRANT CONNECT ON DATABASE ehlog TO leech;
GRANT USAGE ON SCHEMA ehealth TO leech;

ALTER DEFAULT PRIVILEGES IN SCHEMA ehealth GRANT SELECT,INSERT,UPDATE,DELETE ON TABLES TO leech;
ALTER DEFAULT PRIVILEGES REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC;

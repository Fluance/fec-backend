-- Role: wso2

DO
$body$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_roles WHERE rolname = 'wso2') THEN
        CREATE ROLE wso2 LOGIN
        PASSWORD 'wso2'
        NOSUPERUSER NOINHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
   END IF;
END
$body$;

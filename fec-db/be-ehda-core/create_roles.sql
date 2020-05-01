-- Role: fluance

DO
$body$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_roles WHERE rolname = 'fluance') THEN
        CREATE ROLE fluance NOLOGIN
        PASSWORD 'fluance'
        NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;

   END IF;
END
$body$;

-- Role: dbinput

DO
$body$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_roles WHERE rolname = 'dbinput') THEN
        CREATE ROLE dbinput LOGIN
        PASSWORD 'dbinput'
        NOSUPERUSER NOINHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
   END IF;
END
$body$;

-- Role: leech

DO
$body$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_roles WHERE rolname = 'leech') THEN
        CREATE ROLE leech LOGIN
        PASSWORD 'leech'
        NOSUPERUSER NOINHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
   END IF;
END
$body$;

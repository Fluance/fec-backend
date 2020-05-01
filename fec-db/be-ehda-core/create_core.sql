\c postgres;

\i create_roles.sql;

\cd granulainbound

\i create_schema.sql;

\cd ../granulaoperate

\i create_schema.sql;

\i create_objects.sql

\cd ../ehlog

\i create_schema.sql;

\i create_objects.sql

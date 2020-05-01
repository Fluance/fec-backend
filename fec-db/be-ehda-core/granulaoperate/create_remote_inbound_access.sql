CREATE SERVER forinbound FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '127.0.0.1', dbname 'granulainbound', port '5432');

CREATE USER MAPPING FOR dbinput SERVER forinbound OPTIONS (user 'dbinput', password 'dbinput');

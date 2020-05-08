# fec-backend
fec-backend code base

## fec-db prerequisites

1. PostgreSQL server version 9.6 or higher

2. [postgresql-contrib](https://www.postgresql.org/docs/9.6/contrib.html) and [postgresql-plpython](https://www.postgresql.org/docs/9.6/plpython.html) packages installed

3. [psql](https://www.postgresql.org/docs/9.6/app-psql.html) installed

## deploy fec-db

1. run create_fec_db.sql script with psql

## fec-mirth prerequisites

fec-mirth is used to process clinical messages to fec-db

1. Mirth connect 3.8

2. Import channels

3. Change source directory according to your needs


\c ehuserprofile

------------ EXTENSIONS -----------
\i extensions/e_postgres_fdw.sql
-----------------------------------

--------- REMOTE ACCESS ------------
\i create_remote_operate_access.sql
------------------------------------

------------ TABLES ---------------
\i tables/usertype.sql
\i tables/profile.sql
\i tables/role.sql
\i tables/profile_role.sql
\i tables/client.sql
\i tables/user_client_data.sql
\i tables/provider.sql
\i tables/profile_identity.sql
\i tables/profile_permission.sql
----------------------------------

----------- FOREIGN TABLES -------
\i foreign/for_company.sql
\i foreign/for_hospservice.sql
\i foreign/for_patientunit.sql
\i foreign/for_physician.sql
\i foreign/for_resource_personnel.sql
----------------------------------

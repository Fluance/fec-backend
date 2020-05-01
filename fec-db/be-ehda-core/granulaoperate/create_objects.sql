\c granulaoperate;

------------ EXTENSIONS -----------
\i extensions/e_postgres_fdw.sql;
\i extensions/e_trgm.sql;
\i extensions/e_plpythonu.sql;
\i extensions/e_unaccent.sql;
----------------------------------

--------- REMOTE ACCESS ------------
\i create_remote_inbound_access.sql;
------------------------------------

------------ TABLES --------------
\i tables/company.sql;
\i tables/catalog.sql;
\i tables/hl7v2tables.sql;
\i tables/refdata.sql;
----------------------------------

---------- FUNCTIONS --------------
\i functions/f_raise_error.sql;
\i functions/f_xml_unescape.sql;
\i functions/tf_last_modified.sql;

\i functions/f_get_contact_eqt.sql;
\i functions/f_get_contact_nbt.sql;
\i functions/f_get_refdata.sql;
\i functions/f_unaccent.sql;
-----------------------------------

------------ M_VIEWS -----------
\i views/m_h2t_ic.sql;
\i views/m_h2t_orsci.sql;
--------------------------------

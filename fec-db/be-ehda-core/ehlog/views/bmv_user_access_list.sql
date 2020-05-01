-- View: bmv_user_access_list

-- DROP VIEW bmv_user_access_list;

CREATE OR REPLACE VIEW bmv_user_access_list AS 
 SELECT DISTINCT ON ((user_access.logdt::date), user_access.appuser, user_access.httpmethod, user_access.objectid, user_access.parentpid, user_access.objecttype, user_access.externaluser) user_access.logdt,
    user_access.objecttype,
    user_access.objectid,
    user_access.displayname,
    user_access.parentpid,
    user_access.parentvn,
    user_access.httpmethod,
    user_access.appuser,
    user_access.firstname,
    user_access.lastname,
    user_access.externaluser,
    user_access.externalfirstname,
    user_access.externallastname,
    user_access.externalemail
   FROM user_access
  ORDER BY (user_access.logdt::date) DESC, user_access.appuser, user_access.httpmethod, user_access.objectid, user_access.parentpid, user_access.objecttype, user_access.externaluser, user_access.logdt DESC;

ALTER TABLE bmv_user_access_list
  OWNER TO fluance;
GRANT ALL ON TABLE bmv_user_access_list TO fluance;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE bmv_user_access_list TO leech;


\c postgres;

CREATE DATABASE ehuserprofile OWNER wso2;

REVOKE ALL ON DATABASE ehuserprofile FROM PUBLIC;

\c ehuserprofile postgres;

ALTER SCHEMA public OWNER TO wso2;

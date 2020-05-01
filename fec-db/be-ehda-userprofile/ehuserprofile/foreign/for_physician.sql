CREATE FOREIGN TABLE IF NOT EXISTS physician (
    id integer ,
    staffid integer ,
    company_id integer
)
server foroperate options(SCHEMA_NAME 'ehealth', updatable 'false');


ALTER TABLE physician OWNER TO wso2;

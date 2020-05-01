CREATE FOREIGN TABLE IF NOT EXISTS resource_personnel (
    id integer,
    staffid varchar,
    company_id integer
)
server foroperate options(SCHEMA_NAME 'ehealth', updatable 'false');


ALTER TABLE resource_personnel OWNER TO wso2;

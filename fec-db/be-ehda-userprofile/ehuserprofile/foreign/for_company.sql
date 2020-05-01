CREATE FOREIGN TABLE IF NOT EXISTS company (
    id integer NOT NULL,
    code character varying(4) NOT NULL
)
SERVER foroperate
OPTIONS(schema_name 'ehealth', updatable 'false');

ALTER TABLE company
  OWNER TO wso2;

CREATE FOREIGN TABLE IF NOT EXISTS m_bmv_hospservice (
    hospservice character varying(20),
    hospservicedesc character varying(255),
    company_id  integer
)
SERVER foroperate
OPTIONS(schema_name 'ehealth', updatable 'false');

ALTER TABLE m_bmv_hospservice
  OWNER TO wso2;

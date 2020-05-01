CREATE FOREIGN TABLE IF NOT EXISTS m_bmv_patientunit (
    patientunit character varying(255),
    patientunitdesc character varying(255),
    company_id  integer
)
SERVER foroperate
OPTIONS(schema_name 'ehealth', updatable 'false');

ALTER TABLE m_bmv_patientunit
  OWNER TO wso2;

CREATE FOREIGN TABLE IF NOT EXISTS demographic_dwo_invoice
(
  control_id UUID NOT NULL,
  dwo_msg JSONB NOT NULL,
  company character varying(4) NOT NULL,
  batchnb BIGINT NOT NULL,
  uploaded TIMESTAMP WITHOUT TIME ZONE NOT NULL
)
SERVER forinbound
OPTIONS(updatable 'false');

ALTER TABLE demographic_dwo_invoice
  OWNER TO fluance;

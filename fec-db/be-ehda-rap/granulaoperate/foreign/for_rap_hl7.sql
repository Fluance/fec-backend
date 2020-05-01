CREATE FOREIGN TABLE IF NOT EXISTS rap_hl7
(
  control_id VARCHAR(255) NOT NULL,
  hl7_msg XML NOT NULL,
  uploaded TIMESTAMP WITHOUT TIME ZONE NOT NULL
)
SERVER forinbound
OPTIONS(updatable 'false');

ALTER TABLE rap_hl7
  OWNER TO fluance;

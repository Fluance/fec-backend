CREATE FOREIGN TABLE IF NOT EXISTS demographic_exp10_benefit (
    control_id UUID NOT NULL,
    exp10_msg JSONB NOT NULL,
    uploaded TIMESTAMP WITHOUT TIME ZONE NOT NULL
)
SERVER forinbound
OPTIONS(updatable 'false');

ALTER TABLE demographic_exp10_benefit
  OWNER TO fluance;

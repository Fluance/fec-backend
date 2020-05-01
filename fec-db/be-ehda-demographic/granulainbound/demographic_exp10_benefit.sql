-- Table: demographic_exp10_benefit

-- DROP TABLE demographic_exp10_benefit;

CREATE TABLE demographic_exp10_benefit (
    control_id UUID NOT NULL,
    exp10_msg JSONB NOT NULL,
    uploaded TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    CONSTRAINT demographic_exp10_ben_pkey PRIMARY KEY (control_id)
);

ALTER TABLE demographic_exp10_benefit
  OWNER TO fluance;

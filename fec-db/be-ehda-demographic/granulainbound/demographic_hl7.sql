-- Table: demographic_hl7

-- DROP TABLE IF EXISTS demographic_hl7;

CREATE TABLE demographic_hl7 (
    control_id VARCHAR(255) NOT NULL,
    hl7_msg XML NOT NULL,
    uploaded TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    CONSTRAINT demographic_hl7_pkey PRIMARY KEY (control_id)
);

ALTER TABLE demographic_hl7
OWNER TO fluance;

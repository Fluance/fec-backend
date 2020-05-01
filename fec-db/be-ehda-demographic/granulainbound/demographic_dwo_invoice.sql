-- Table: demographic_dwo_invoice

-- DROP TABLE IF EXISTS demographic_dwo_invoice;

CREATE TABLE demographic_dwo_invoice (
    control_id UUID NOT NULL,
    dwo_msg JSONB NOT NULL,
    company character varying(4) NOT NULL,
    batchnb BIGINT NOT NULL,
    uploaded TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    CONSTRAINT demographic_dwo_invoice_pkey PRIMARY KEY (control_id)
);

ALTER TABLE demographic_dwo_invoice
OWNER TO fluance;

-- Index: idx_odi_com_bat

CREATE INDEX idx_odi_bat
  ON demographic_dwo_invoice
  USING btree
  (batchnb);

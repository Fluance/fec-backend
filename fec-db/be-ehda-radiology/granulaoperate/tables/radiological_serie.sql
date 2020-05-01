-- Table: radiological_serie

CREATE TABLE radiological_serie
(
  serieiuid character varying(255) NOT NULL,
  patient_id bigint NOT NULL,
  company_id integer NOT NULL,
  ordernb character varying(255) NOT NULL,
  diagnosticservice character varying(50) NOT NULL,
  serieobs character varying(255),
  serieobsdt timestamp without time zone NOT NULL,
  orderobs character varying(255),
  orderurl character varying(255) NOT NULL,
  source character varying(50),
  sourceid character varying(255),
  lastmodified timestamp without time zone,
  online boolean NOT NULL DEFAULT true,
  CONSTRAINT radiological_serie_pkey PRIMARY KEY (serieiuid),
  CONSTRAINT fk_rs_pat FOREIGN KEY (patient_id)
    REFERENCES patient (id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT fk_rx_com FOREIGN KEY (company_id)
    REFERENCES company (id) MATCH SIMPLE
    ON UPDATE CASCADE ON DELETE RESTRICT
)
WITH (
  OIDS=FALSE
);

ALTER TABLE radiological_serie
  OWNER TO fluance;

-- Index: fki_rs_pat

CREATE INDEX fki_rs_pat
  ON radiological_serie
  USING btree
  (patient_id);

-- Index: fki_rs_com

CREATE INDEX fki_rs_com
  ON radiological_serie
  USING btree
  (company_id);

-- Index: idx_rs_onb

CREATE INDEX idx_rs_onb
  ON radiological_serie
  USING btree
  (ordernb);

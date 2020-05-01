-- Table: radiological_report

CREATE TABLE radiological_report
(
  studyuid character varying(255) NOT NULL,
  patient_id bigint NOT NULL,
  company_id integer NOT NULL,
  ordernb character varying(255) NOT NULL,
  studydt timestamp without time zone,
  report text NOT NULL,
  completion character varying(255),
  verification character varying(255),
  referringphysician character varying(255),
  recordphysician character varying(255),
  performingphysician character varying(255),
  readingphysician character varying(255),
  source character varying(50),
  sourceid character varying(255),
  lastmodified timestamp without time zone,
  CONSTRAINT radiological_report_pkey PRIMARY KEY (studyuid),
  CONSTRAINT fk_rr_pat FOREIGN KEY (patient_id)
    REFERENCES patient (id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT fk_rr_com FOREIGN KEY (company_id)
    REFERENCES company (id) MATCH SIMPLE
    ON UPDATE CASCADE ON DELETE RESTRICT
)
WITH (
  OIDS=FALSE
);

ALTER TABLE radiological_report
  OWNER TO fluance;

-- Index: fki_rr_pat

CREATE INDEX fki_rr_pat
  ON radiological_report
  USING btree
  (patient_id);

-- Index: fki_rr_com

CREATE INDEX fki_rr_com
  ON radiological_report
  USING btree
  (company_id);

-- Index: idx_rr_onb

CREATE INDEX idx_rr_onb
  ON radiological_report
  USING btree
  (ordernb);

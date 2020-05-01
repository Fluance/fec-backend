-- Table: patient_contact

-- DROP TABLE patient_contact;

CREATE TABLE patient_contact
(
  patient_id bigint NOT NULL,
  contact_id bigint NOT NULL,
  CONSTRAINT patient_contact_pkey PRIMARY KEY (patient_id, contact_id),
  CONSTRAINT fk_pat_con_con FOREIGN KEY (contact_id)
      REFERENCES contact (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT fk_pat_con_pat FOREIGN KEY (patient_id)
      REFERENCES patient (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

ALTER TABLE patient_contact
  OWNER TO fluance;

-- Index: fki_pat_con_con

CREATE INDEX fki_pat_con_con
  ON patient_contact
  USING btree
  (contact_id);

-- Index: fki_pat_con_pat

CREATE INDEX fki_pat_con_pat
  ON patient_contact
  USING btree
  (patient_id);

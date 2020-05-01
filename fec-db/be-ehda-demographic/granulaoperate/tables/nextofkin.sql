-- Table: nextofkin

-- DROP TABLE nextofkin;

CREATE TABLE nextofkin
(
  id bigserial NOT NULL,
  patient_id bigint NOT NULL,
  lastname character varying(255),
  firstname character varying(255),
  courtesy character varying(255),
  type character varying(255),
  address character varying(255),
  address2 character varying(255),
  careof character varying(255),
  locality character varying(255),
  postcode character varying(255),
  canton character varying(255),
  country character varying(255),
  complement character varying(255),
  jobtitle character varying(255),
  employer character varying(255),
  workplace character varying(255),
  relationship character varying(255),
  addresstype character(1),
  source character varying(50),
  sourceid character varying(255),
  CONSTRAINT nextofkin_pkey PRIMARY KEY (id),
  CONSTRAINT fk_nok_pat FOREIGN KEY (patient_id)
      REFERENCES patient (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nextofkin
  OWNER TO fluance;

-- Index: fki_nok_pat

CREATE INDEX fki_nok_pat
  ON nextofkin
  USING btree
  (patient_id);

-- Table: guarantor_contact

-- DROP TABLE guarantor_contact;

CREATE TABLE guarantor_contact
(
  guarantor_id integer NOT NULL,
  contact_id bigint NOT NULL,
  CONSTRAINT guarantor_contact_pkey PRIMARY KEY (guarantor_id, contact_id),
  CONSTRAINT fk_gua_con_con FOREIGN KEY (contact_id)
      REFERENCES contact (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT fk_gua_con_gua FOREIGN KEY (guarantor_id)
      REFERENCES guarantor (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

ALTER TABLE guarantor_contact
  OWNER TO fluance;

-- Index: fki_gua_con_con

CREATE INDEX fki_gua_con_con
  ON guarantor_contact
  USING btree
  (contact_id);

-- Index: fki_gua_con_gua

CREATE INDEX fki_gua_con_gua
  ON guarantor_contact
  USING btree
  (guarantor_id);

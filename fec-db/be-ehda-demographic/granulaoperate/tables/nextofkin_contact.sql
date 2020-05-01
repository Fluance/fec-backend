-- Table: nextofkin_contact

-- DROP TABLE nextofkin_contact;

CREATE TABLE nextofkin_contact
(
  nextofkin_id bigint NOT NULL,
  contact_id bigint NOT NULL,
  CONSTRAINT nextofkin_contact_pkey PRIMARY KEY (nextofkin_id, contact_id),
  CONSTRAINT fk_nok_con_con FOREIGN KEY (contact_id)
      REFERENCES contact (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT fk_nok_con_nok FOREIGN KEY (nextofkin_id)
      REFERENCES nextofkin (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

ALTER TABLE nextofkin_contact
  OWNER TO fluance;

-- Index: fki_nok_con_con

CREATE INDEX fki_nok_con_con
  ON nextofkin_contact
  USING btree
  (contact_id);

-- Index: fki_nok_con_nok

CREATE INDEX fki_nok_con_nok
  ON nextofkin_contact
  USING btree
  (nextofkin_id);

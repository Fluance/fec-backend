-- Table: physician_contact

-- DROP TABLE physician_contact;

CREATE TABLE physician_contact
(
  physician_id integer NOT NULL,
  contact_id bigint NOT NULL,
  CONSTRAINT physician_contact_pkey PRIMARY KEY (physician_id, contact_id),
  CONSTRAINT fk_phy_con_con FOREIGN KEY (contact_id)
      REFERENCES contact (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT fk_phy_con_phy FOREIGN KEY (physician_id)
      REFERENCES physician (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

ALTER TABLE physician_contact
  OWNER TO fluance;

-- Index: fki_phy_con_con

CREATE INDEX fki_phy_con_con
  ON physician_contact
  USING btree
  (contact_id);

-- Index: fki_phy_con_phy

CREATE INDEX fki_phy_con_phy
  ON physician_contact
  USING btree
  (physician_id);

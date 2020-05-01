-- Table: visit_physician

-- DROP TABLE visit_physician;

CREATE TABLE visit_physician
(
  visit_nb bigint NOT NULL,
  attending_physician_id integer,
  referring_physician_id integer,
  consulting_physician_id integer,
  admitting_physician_id integer,
  source character varying(50),
  sourceid character varying(255),
  CONSTRAINT visit_physician_pkey PRIMARY KEY (visit_nb),
  CONSTRAINT fk_vis_att_phy FOREIGN KEY (attending_physician_id)
      REFERENCES physician (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE RESTRICT,
  CONSTRAINT fk_vis_ref_phy FOREIGN KEY (referring_physician_id)
      REFERENCES physician (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE RESTRICT,
  CONSTRAINT fk_vis_con_phy FOREIGN KEY (consulting_physician_id)
      REFERENCES physician (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE RESTRICT,
  CONSTRAINT fk_vis_adm_phy FOREIGN KEY (admitting_physician_id)
      REFERENCES physician (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE RESTRICT,
  CONSTRAINT fk_vis_phy_vis FOREIGN KEY (visit_nb)
      REFERENCES visit (nb) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE visit_physician
  OWNER TO fluance;

-- Index: fki_vis_att_phy

CREATE INDEX fki_vis_att_phy
  ON visit_physician
  USING btree
  (attending_physician_id);

-- Index: fki_vis_ref_phy

CREATE INDEX fki_vis_ref_phy
  ON visit_physician
  USING btree
  (referring_physician_id);

-- Index: fki_vis_con_phy

CREATE INDEX fki_vis_con_phy
  ON visit_physician
  USING btree
  (consulting_physician_id);

-- Index: fki_vis_adm_phy

CREATE INDEX fki_vis_adm_phy
  ON visit_physician
  USING btree
  (admitting_physician_id);

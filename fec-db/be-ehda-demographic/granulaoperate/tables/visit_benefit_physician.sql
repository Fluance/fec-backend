-- Table: visit_benefit_physician

-- DROP TABLE visit_benefit_physician;

CREATE TABLE visit_benefit_physician
(
  visit_benefit_id bigint NOT NULL,
  operating_physician_id integer,
  paid_physician_id integer,
  lead_physician_id integer,
  source character varying(50),
  sourceid character varying(255),
  CONSTRAINT visit_benefit_physician_pkey PRIMARY KEY (visit_benefit_id),
  CONSTRAINT fk_vis_ben_phy_ope FOREIGN KEY (operating_physician_id)
      REFERENCES physician (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE RESTRICT,
  CONSTRAINT fk_vis_ben_phy_pai FOREIGN KEY (paid_physician_id)
      REFERENCES physician (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE RESTRICT,
   CONSTRAINT fk_vis_ben_phy_lea FOREIGN KEY (lead_physician_id)
      REFERENCES physician (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE RESTRICT,
  CONSTRAINT fk_vis_ben_phy_vis_ben FOREIGN KEY (visit_benefit_id)
      REFERENCES visit_benefit (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

ALTER TABLE visit_benefit_physician
  OWNER TO fluance;

-- Index: fki_vis_ben_phy_ope

CREATE INDEX fki_vis_ben_phy_ope
  ON visit_benefit_physician
  USING btree
  (operating_physician_id);

-- Index: fki_vis_ben_phy_pai

CREATE INDEX fki_vis_ben_phy_pai
  ON visit_benefit_physician
  USING btree
  (paid_physician_id);

-- Index: fki_vis_ben_phy_lea

CREATE INDEX fki_vis_ben_phy_lea
  ON visit_benefit_physician
  USING btree
  (lead_physician_id);

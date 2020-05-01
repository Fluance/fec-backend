-- Table: visit_intervention_healthcare

CREATE TABLE visit_intervention_healthcare
(
  visit_nb bigint NOT NULL,
  data character varying(255) NOT NULL,
  type character varying(10) NOT NULL,
  rank smallint NOT NULL,
  source character varying(50),
  sourceid character varying(255),
  CONSTRAINT visit_intervention_healthcare_pkey PRIMARY KEY (visit_nb, type, rank),
  CONSTRAINT fk_vis_int_hea_vis FOREIGN KEY (visit_nb)
      REFERENCES visit (nb) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

ALTER TABLE visit_intervention_healthcare
  OWNER TO fluance;

-- Index: fki_vis_int_hea_vis

CREATE INDEX fki_vis_int_hea_vis
  ON visit_intervention_healthcare
  USING btree
  (visit_nb);

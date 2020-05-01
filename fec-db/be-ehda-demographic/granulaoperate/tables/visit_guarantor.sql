-- Table: visit_guarantor

-- DROP TABLE visit_guarantor;

CREATE TABLE visit_guarantor
(
  visit_nb bigint NOT NULL,
  guarantor_id integer NOT NULL,
  priority smallint NOT NULL,
  accidentnb character varying(255),
  accidentdate date,
  begindate date,
  enddate date,
  covercardnb numeric(20,0),
  policynb character varying(255),
  inactive boolean,
  subpriority smallint NOT NULL,
  hospclass character varying(255),
  source character varying(50),
  sourceid character varying(255),
  CONSTRAINT visit_guarantor_pkey PRIMARY KEY (visit_nb, guarantor_id, priority, subpriority),
  CONSTRAINT fk_vis_gua_gua FOREIGN KEY (guarantor_id)
      REFERENCES guarantor (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE RESTRICT,
  CONSTRAINT fki_vis_gua_vis FOREIGN KEY (visit_nb)
      REFERENCES visit (nb) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE visit_guarantor
  OWNER TO fluance;

-- Index: fki_vis_gua_gua

CREATE INDEX fki_vis_gua_gua
  ON visit_guarantor
  USING btree
  (guarantor_id);

-- Index: fki_vis_gua_vis

CREATE INDEX fki_vis_gua_vis
  ON visit_guarantor
  USING btree
  (visit_nb);

-- Table: leaveofabsence

-- DROP TABLE leaveofabsence;

CREATE TABLE leaveofabsence
(
  id serial NOT NULL,
  visit_nb bigint NOT NULL,
  sequencenb integer NOT NULL,
  startdt timestamp without time zone,
  enddt timestamp without time zone,
  source character varying(50),
  sourceid character varying(255),
  CONSTRAINT un_loa UNIQUE (visit_nb, sequencenb),
  CONSTRAINT leaveofabsence_pkey PRIMARY KEY (id),
  CONSTRAINT fk_loa_vis FOREIGN KEY (visit_nb)
      REFERENCES visit (nb) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE leaveofabsence
  OWNER TO fluance;

-- Index: fki_loa_vis

CREATE INDEX fki_loa_vis
  ON leaveofabsence
  USING btree
  (visit_nb);

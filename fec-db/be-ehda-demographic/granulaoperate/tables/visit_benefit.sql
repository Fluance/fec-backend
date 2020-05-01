-- Table: visit_benefit

-- DROP TABLE visit_benefit;

CREATE TABLE visit_benefit
(
  id bigserial NOT NULL,
  visit_nb bigint NOT NULL,
  internalnb integer NOT NULL,
  sequencenb integer NOT NULL,
  code character varying(50) NOT NULL,
  benefitdt timestamp without time zone,
  quantity numeric(13,4),
  side character(1),
  actingdpt character varying(10),
  actingdptdesc character varying(150),
  note text,
  visamodifier character varying(4),
  modifieddt timestamp without time zone,
  source character varying(50),
  sourceid uuid,
  CONSTRAINT visit_benefit_pkey PRIMARY KEY (id),
  CONSTRAINT fk_vis_ben_vis FOREIGN KEY (visit_nb)
    REFERENCES visit (nb) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE RESTRICT,
  CONSTRAINT un_vis_ben_vis_int_seq UNIQUE(visit_nb, internalnb, sequencenb)
)
WITH (
  OIDS=FALSE
);

ALTER TABLE visit_benefit
  OWNER TO fluance;

-- Index: fki_vis_ben_vis

CREATE INDEX fki_vis_ben_vis
  ON visit_benefit
  USING btree
  (visit_nb);

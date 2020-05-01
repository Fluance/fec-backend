-- Table: visit_obs_result

-- DROP TABLE visit_obs_result;

CREATE TABLE visit_obs_result
(
  id bigserial NOT NULL,
  visit_nb bigint NOT NULL,
  valuetype character varying(255),
  identifier character varying(255),
  value character varying(255),
  unit character varying(255),
  resultstatus character varying(255),
  source character varying(50),
  sourceid character varying(255),
  CONSTRAINT visit_obs_result_pkey PRIMARY KEY (id),
  CONSTRAINT fk_obs_vis FOREIGN KEY (visit_nb)
      REFERENCES visit (nb) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE visit_obs_result
  OWNER TO fluance;

-- Index: fki_obs_vis

CREATE INDEX fki_obs_vis
  ON visit_obs_result
  USING btree
  (visit_nb);

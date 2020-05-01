-- Table: appointment_resource_personnel

-- DROP TABLE appointment_resource_personnel;

CREATE TABLE appointment_resource_personnel
(
  id bigserial NOT NULL,
  appoint_id bigint NOT NULL,
  rp_id integer NOT NULL,
  begindt timestamp without time zone,
  duration integer,
  occupationcode character varying (10),
  CONSTRAINT appointment_resource_personnel_pkey PRIMARY KEY (id),
  CONSTRAINT fk_app_res_per_app FOREIGN KEY (appoint_id)
      REFERENCES appointment (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT fk_app_res_per_res_per FOREIGN KEY (rp_id)
      REFERENCES resource_personnel (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

ALTER TABLE appointment_resource_personnel
  OWNER TO fluance;

-- Index: fki_app_res_per_app

CREATE INDEX fki_app_res_per_app
  ON appointment_resource_personnel
  USING btree
  (appoint_id);

-- Index: fki_app_res_per_rp

CREATE INDEX fki_app_res_per_rp
  ON appointment_resource_personnel
  USING btree
  (rp_id);

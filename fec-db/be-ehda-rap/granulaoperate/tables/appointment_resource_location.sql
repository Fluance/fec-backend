-- Table: appointment_resource_location

-- DROP TABLE appointment_resource_location;

CREATE TABLE appointment_resource_location
(
  id bigserial NOT NULL,
  appoint_id bigint NOT NULL,
  rl_id integer NOT NULL,
  begindt timestamp without time zone,
  duration integer,
  CONSTRAINT appointment_resource_location_pkey PRIMARY KEY (id),
  CONSTRAINT fk_app_res_loc_app FOREIGN KEY (appoint_id)
      REFERENCES appointment (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT fk_app_res_loc_res_loc FOREIGN KEY (rl_id)
      REFERENCES resource_location (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

ALTER TABLE appointment_resource_location
  OWNER TO fluance;

-- Index: fki_app_res_loc_app

CREATE INDEX fki_app_res_loc_app
  ON appointment_resource_location
  USING btree
  (appoint_id);

-- Index: fki_app_res_loc_rl

CREATE INDEX fki_app_res_loc_rl
  ON appointment_resource_location
  USING btree
  (rl_id);
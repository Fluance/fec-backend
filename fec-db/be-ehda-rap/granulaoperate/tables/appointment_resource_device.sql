-- Table: appointment_resource_device

-- DROP TABLE appointment_resource_device;

CREATE TABLE appointment_resource_device
(
  id bigserial NOT NULL,
  appoint_id bigint NOT NULL,
  rd_id integer NOT NULL,
  begindt timestamp without time zone,
  duration integer,
  CONSTRAINT appointment_resource_device_pkey PRIMARY KEY (id),
  CONSTRAINT fk_app_res_dev_app FOREIGN KEY (appoint_id)
      REFERENCES appointment (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT fk_app_res_dev_res_dev FOREIGN KEY (rd_id)
      REFERENCES resource_device (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

ALTER TABLE appointment_resource_device
  OWNER TO fluance;

-- Index: fki_app_res_dev_app

CREATE INDEX fki_app_res_dev_app
  ON appointment_resource_device
  USING btree
  (appoint_id);

-- Index: fki_app_res_dev_rd

CREATE INDEX fki_app_res_dev_rd
  ON appointment_resource_device
  USING btree
  (rd_id);
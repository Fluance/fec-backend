-- Table: appointment_process_status

-- DROP TABLE appointment_process_status;

CREATE TABLE appointment_process_status
(
  appoint_id bigint NOT NULL,
  ps_id integer NOT NULL,
  nb integer NOT NULL,
  eventdt timestamp without time zone NOT NULL,
  CONSTRAINT appointment_process_status_pkey PRIMARY KEY (appoint_id, ps_id),
  CONSTRAINT fk_app_pro_sta_app FOREIGN KEY (appoint_id)
      REFERENCES appointment (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT fk_app_pro_sta_pro_sta FOREIGN KEY (ps_id)
      REFERENCES process_status (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

ALTER TABLE appointment_process_status
  OWNER TO fluance;

-- Index: fki_app_pro_sta_app

CREATE INDEX fki_app_pro_sta_app
  ON appointment_process_status
  USING btree
  (appoint_id);

-- Index: fki_app_pro_sta_ps

CREATE INDEX fki_app_pro_sta_ps
  ON appointment_process_status
  USING btree
  (ps_id);
-- Table: appointment

-- DROP TABLE appointment;

CREATE TABLE appointment
(
  id bigserial NOT NULL,
  company_id integer NOT NULL,
  aid integer NOT NULL,
  agid integer,
  scheduleid integer,
  scheduledesc text,
  visit_nb bigint NOT NULL,
  begindt timestamp without time zone NOT NULL,
  enddt timestamp without time zone NOT NULL,
  duration integer,
  type character varying(255),
  description text,
  status character varying(255),
  rank integer,
  source character varying(50),
  sourceid character varying(255),
  lastmodified timestamp without time zone,
  appointkindcode character varying(255),
  appointkinddescription character varying(255),
  CONSTRAINT appointment_pkey PRIMARY KEY (id),
  CONSTRAINT fk_app_com FOREIGN KEY (company_id)
      REFERENCES company (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_app_vis FOREIGN KEY (visit_nb)
      REFERENCES visit (nb) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT un_app_aid_company UNIQUE(aid, company_id)
)
WITH (
  OIDS=FALSE
);

ALTER TABLE appointment
  OWNER TO fluance;

-- Index: fki_app_com

CREATE INDEX fki_app_com
  ON appointment
  USING btree
  (company_id);

-- Index: fki_app_vis

CREATE INDEX fki_app_vis
  ON appointment
  USING btree
  (visit_nb);

-- Index: idx_app_type_bdt

CREATE INDEX idx_app_type_bdt
ON appointment
USING btree
(type,begindt);

-- Index: idx_app_status_edt

CREATE INDEX idx_app_status_edt
ON appointment
USING btree
(status,enddt);

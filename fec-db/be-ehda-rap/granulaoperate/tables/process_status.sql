-- Table Process_Status

-- DROP TABLE process_status

CREATE TABLE process_status
(
  id serial not null,
  company_id integer NOT NULL,
  psid integer NOT NULL,
  eventcode character varying(255),
  event text NOT NULL,
  source character varying(50),
  sourceid character varying(255),
  lastmodified timestamp without time zone,
  CONSTRAINT process_status_pkey PRIMARY KEY (id),
  CONSTRAINT fk_pro_sta_com FOREIGN KEY (company_id)
      REFERENCES company (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT un_pro_sta_psid_company_id UNIQUE(psid, company_id)
)
WITH (
  OIDS=FALSE
);

ALTER TABLE process_status
  OWNER TO fluance;

-- Index: fki_pro_sta_com

-- DROP INDEX fki_pro_sta_com;
CREATE INDEX fki_pro_sta_com
  ON process_status
  USING btree
  (company_id);

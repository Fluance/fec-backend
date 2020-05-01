CREATE TABLE resource_device
(
  id serial NOT NULL,
  company_id integer NOT NULL,
  rsid integer NOT NULL,
  name character varying(255),
  type character varying(255),
  source character varying(50),
  sourceid character varying(255),
  lastmodified timestamp without time zone,
  CONSTRAINT resource_device_pkey PRIMARY KEY (id),
  CONSTRAINT fk_res_dev_com FOREIGN KEY (company_id)
      REFERENCES company (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT un_res_dev_rsid_company_id UNIQUE(rsid, company_id)
)
WITH (
  OIDS=FALSE
);

ALTER TABLE resource_device
  OWNER TO fluance;

-- Index: fki_res_dev_com

-- DROP INDEX fki_res_dev_com;
CREATE INDEX fki_res_dev_com
  ON resource_device
  USING btree
  (company_id);

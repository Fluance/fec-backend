-- Table: resource_location

-- DROP TABLE resource_location;

CREATE TABLE resource_location
(
  id serial NOT NULL,
  company_id integer NOT NULL,
  rsid integer NOT NULL,
  name character varying(255),
  type character varying(255),
  source character varying(50),
  sourceid character varying(255),
  lastmodified timestamp without time zone,
  CONSTRAINT resource_location_pkey PRIMARY KEY (id),
  CONSTRAINT fk_res_loc_com FOREIGN KEY (company_id)
      REFERENCES company (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT un_res_loc_rsid_company_id UNIQUE(rsid, company_id)
)
WITH (
  OIDS=FALSE
);

ALTER TABLE resource_location
  OWNER TO fluance;

-- Index: fki_res_loc_com

-- DROP INDEX fki_res_loc_com;

CREATE INDEX fki_res_loc_com
  ON resource_location
  USING btree
  (company_id);

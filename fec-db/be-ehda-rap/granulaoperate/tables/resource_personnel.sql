-- Table: resource_personnel

-- DROP TABLE resource_personnel;

CREATE TABLE resource_personnel
(
  id serial NOT NULL,
  company_id integer NOT NULL,
  rsid integer NOT NULL,
  staffid character varying(255),
  role character varying(255),
  name character varying(255),
  address character varying(255),
  address2 character varying(255),
  postcode character varying(255),
  locality character varying(255),
  internalphone character varying(255),
  privatephone character varying(255),
  altphone character varying(255),
  fax character varying(255),
  source character varying(50),
  sourceid character varying(255),
  lastmodified timestamp without time zone,
  CONSTRAINT resource_personnel_pkey PRIMARY KEY (id),
  CONSTRAINT fk_res_per_com FOREIGN KEY (company_id)
      REFERENCES company (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT un_res_per_rsid_company UNIQUE(rsid, company_id)
)
WITH (
  OIDS=FALSE
);

ALTER TABLE resource_personnel
  OWNER TO fluance;

-- Index: fki_res_per_com

-- DROP INDEX fki_res_per_com;

CREATE INDEX fki_res_per_com
  ON resource_personnel
  USING btree
  (company_id);

-- Index: idx_res_per_sta

CREATE INDEX idx_res_per_sta
  ON resource_personnel
  USING btree
  (staffid);
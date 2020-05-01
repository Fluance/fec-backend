-- Table: physician

-- DROP TABLE physician;

CREATE TABLE physician
(
  id serial NOT NULL,
  lastname character varying(255) NOT NULL,
  firstname character varying(255),
  prefix character varying(255),
  staffid integer NOT NULL,
  alternateid character varying(255),
  alternateidname character varying(255),
  speciality character varying(255),
  address character varying(255),
  locality character varying(255),
  postcode character varying(255),
  canton character varying(255),
  country character varying(255),
  complement character varying(255),
  language character varying(255),
  startdate date,
  enddate date,
  employmentcode character varying(255),
  company_id integer NOT NULL,
  occasional boolean DEFAULT false,
  source character varying(50),
  sourceid character varying(255),
  lastmodified timestamp without time zone,
  CONSTRAINT physician_pkey PRIMARY KEY (id),
  CONSTRAINT fk_phy_com FOREIGN KEY (company_id)
      REFERENCES company (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT un_phy_staffid_company UNIQUE(staffid, company_id)
)
WITH (
  OIDS=FALSE
);

ALTER TABLE physician
  OWNER TO fluance;

-- Index: fki_phy_com

CREATE INDEX fki_phy_com
  ON physician
  USING btree
  (company_id);

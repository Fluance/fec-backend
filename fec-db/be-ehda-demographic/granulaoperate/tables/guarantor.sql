-- Table: guarantor

-- DROP TABLE guarantor;

CREATE TABLE guarantor
(
  id serial NOT NULL,
  code character varying(255) NOT NULL,
  name character varying(255) NOT NULL,
  address character varying(255),
  address2 character varying(255),
  locality character varying(255),
  postcode character varying(255),
  canton character varying(255),
  country character varying(255),
  complement character varying(255),
  begindate date,
  enddate date,
  occasional boolean DEFAULT false,
  source character varying(50),
  sourceid character varying(255),
  lastmodified timestamp without time zone,
  CONSTRAINT guarantor_pkey PRIMARY KEY (id),
  CONSTRAINT un_gua_code UNIQUE (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE guarantor
  OWNER TO fluance;

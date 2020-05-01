-- Table: company

-- DROP TABLE company;

CREATE TABLE company
(
  id serial NOT NULL,
  code character varying(4) NOT NULL,
  name character varying(255) NOT NULL,
  address character varying(255),
  locality character varying(255),
  postcode character varying(255),
  canton character varying(255),
  country character varying(255),
  phone character varying(255),
  fax character varying(255),
  email character varying(255),
  preflang character(3),
  CONSTRAINT company_pkey PRIMARY KEY (id),
  CONSTRAINT un_com_code UNIQUE (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE company
  OWNER TO fluance;

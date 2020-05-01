-- Table: refdata

-- DROP TABLE refdata;

CREATE TABLE refdata
(
  src character varying(50) NOT NULL,
  srctable character varying(50) NOT NULL,
  company character varying(4) NOT NULL,
  lang character(3),
  code character varying(50) NOT NULL,
  codedesc character varying(255),
  hl7code character varying(10),
  hl7desc character varying(255),
  begindate date,
  enddate date,
  CONSTRAINT refdata_pkey PRIMARY KEY (src, srctable, company, code, lang)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE refdata
  OWNER TO fluance;

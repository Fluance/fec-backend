-- Table: hl7v2tables

-- DROP TABLE hl7v2tables;

CREATE TABLE hl7v2tables
(
  id character varying(255) NOT NULL,
  code character varying(255) NOT NULL,
  description text,
  domaindata character varying(255),
  CONSTRAINT hl7v2tables_pkey PRIMARY KEY (id,code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE hl7v2tables
  OWNER TO fluance;

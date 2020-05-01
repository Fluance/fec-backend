-- Table: invoice

-- DROP TABLE invoice;

CREATE TABLE invoice
(
  id bigint NOT NULL,
  reversalnb bigint,
  invdt timestamp without time zone,
  total numeric(11,2),
  balance numeric(11,2),
  apdrg_code character varying(50),
  apdrg_descr character varying(255),
  mdc_code character varying(50),
  mdc_descr character varying(255),
  batchnb bigint,
  source character varying(50),
  sourceid character varying(255),
  lastmodified timestamp without time zone,
  CONSTRAINT invoice_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE invoice
  OWNER TO fluance;

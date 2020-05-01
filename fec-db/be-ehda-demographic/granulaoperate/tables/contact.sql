-- Table: contact

-- DROP TABLE contact;

CREATE TABLE contact
(
  id bigserial NOT NULL,
  nbtype contact_nbtype,
  equipment contact_equipment NOT NULL,
  data character varying(255) NOT NULL,
  holder character varying(255),
  source character varying(50),
  sourceid character varying(255),
  CONSTRAINT contact_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);

ALTER TABLE contact
  OWNER TO fluance;

-- Table: catalog

-- DROP TABLE catalog;

CREATE TABLE catalog
(
    code character varying(50) NOT NULL,
    abbreviation character varying(50),
    lang character(3) NOT NULL,
    description  text,
    name text,
    type character varying(50) NOT NULL,
    CONSTRAINT catalog_pkey PRIMARY KEY (code, lang, type)
)
WITH (
    OIDS=FALSE
);

ALTER TABLE catalog
OWNER TO fluance;

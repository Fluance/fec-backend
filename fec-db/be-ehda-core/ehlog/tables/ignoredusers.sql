-- Table: ignoredusers

CREATE TABLE ignoredusers
(
  appuser character varying(255) PRIMARY KEY
)
WITH (
  OIDS=FALSE
);

ALTER TABLE ignoredusers
  OWNER TO fluance;

-- Table: system_access

CREATE TABLE system_access
(
  logdt timestamp without time zone NOT NULL,
  objecttype character varying(255) NOT NULL,
  objectid character varying(255),
  parentpid character varying(255),
  parentvn character varying(255),
  httpmethod character varying(255) NOT NULL,
  appuser character varying(255) NOT NULL,
  uri text NOT NULL,
  parameters text
)
WITH (
  OIDS=FALSE
);

ALTER TABLE system_access
  OWNER TO fluance;

-- Index: idx_sa_parentpid

CREATE INDEX idx_sa_parentpid
  ON system_access
  USING btree
  (parentpid);

-- Index: idx_sa_parentvn

CREATE INDEX idx_sa_parentvn
  ON system_access
  USING btree
  (parentvn);

-- Table: user_access

-- DROP TABLE user_access;

CREATE TABLE user_access
(
  logdt timestamp without time zone NOT NULL,
  objecttype character varying(255) NOT NULL,
  objectid character varying(255),
  displayname text NOT NULL,
  parentpid character varying(255),
  parentvn character varying(255),
  httpmethod character varying(255) NOT NULL,
  appuser character varying(255) NOT NULL,
  firstname character varying(255),
  lastname character varying(255),
  externaluser character varying(255),
  externalfirstname character varying(255),
  externallastname character varying(255),
  externalemail character varying(255)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE user_access
  OWNER TO fluance;

-- Index: idx_ua_parentpid

CREATE INDEX idx_ua_parentpid
  ON user_access
  USING btree
  (parentpid);

-- Index: idx_ua_parentvn

CREATE INDEX idx_ua_parentvn
  ON user_access
  USING btree
  (parentvn);

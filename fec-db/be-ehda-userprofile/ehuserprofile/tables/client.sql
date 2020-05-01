-- Table: client

-- DROP TABLE client;

CREATE TABLE client
(
    id UUID NOT NULL,
    secret character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description TEXT NOT NULL,
    CONSTRAINT client_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE client
  OWNER TO wso2;

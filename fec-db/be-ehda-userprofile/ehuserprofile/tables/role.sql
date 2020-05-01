-- Table: role

-- DROP TABLE role;

CREATE TABLE role
(
  id serial NOT NULL,
  name character varying(255) NOT NULL,
  description character varying(255),
  CONSTRAINT role_pkey PRIMARY KEY (id),
  CONSTRAINT un_role_name UNIQUE (name)
)
WITH (
  OIDS=FALSE
);

ALTER TABLE role
  OWNER TO wso2;

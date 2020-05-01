-- Table: usertype

-- DROP TABLE user_type;

CREATE TABLE usertype
(
    id serial NOT NULL,
    type character varying (255) NOT NULL,
    description character varying (255),
    CONSTRAINT usertype_pkey PRIMARY KEY (id),
    CONSTRAINT un_usertype UNIQUE (type)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE usertype
  OWNER TO wso2;

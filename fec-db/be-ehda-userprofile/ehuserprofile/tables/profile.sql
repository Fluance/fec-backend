-- Table: profile

-- DROP TABLE profile;

CREATE TABLE profile
(
    id serial NOT NULL,
    domainname character varying(255) NOT NULL,
    username character varying(255) NOT NULL,
    language character varying(255) DEFAULT 'en'::character varying,
    usertype_id integer NOT NULL,
    CONSTRAINT profile_pkey PRIMARY KEY (id),
    CONSTRAINT un_pro_user_domain UNIQUE (username, domainname),
    CONSTRAINT fk_pro_user_type FOREIGN KEY (usertype_id)
      REFERENCES usertype (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT
)
WITH (
  OIDS=FALSE
);
ALTER TABLE profile
  OWNER TO wso2;

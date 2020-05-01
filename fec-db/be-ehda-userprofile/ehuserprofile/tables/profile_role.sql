-- Table: profile_role

-- DROP TABLE profile_role;

CREATE TABLE profile_role
(
  profile_id integer NOT NULL,
  role_id integer NOT NULL,
  CONSTRAINT profile_role_pkey PRIMARY KEY (profile_id, role_id),
  CONSTRAINT fk_role FOREIGN KEY (role_id)
      REFERENCES role (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_profile FOREIGN KEY (profile_id)
      REFERENCES profile (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

ALTER TABLE profile_role
  OWNER TO wso2;

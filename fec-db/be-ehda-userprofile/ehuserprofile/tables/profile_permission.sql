-- Table: profile_permission

-- DROP TABLE profile_permission;

CREATE TABLE profile_permission
(
    profile_id integer NOT NULL,
    company_id integer NOT NULL,
    location JSON,
    CONSTRAINT profile_permission_pkey PRIMARY KEY (profile_id, company_id),
    CONSTRAINT fk_prf_pem_prv FOREIGN KEY (profile_id)
        REFERENCES profile (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
    OIDS=FALSE
);

ALTER TABLE profile_permission
    OWNER TO wso2;

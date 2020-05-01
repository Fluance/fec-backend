-- Table: profile_identity

-- DROP TABLE profile_identity;

CREATE TABLE profile_identity
(
    profile_id integer NOT NULL,
    company_id integer NOT NULL,
    provider_id integer NOT NULL,
    staffid character varying(255) NOT NULL,
    CONSTRAINT profile_identity_pkey PRIMARY KEY (profile_id, company_id, provider_id),
    CONSTRAINT fk_prf_ide_prv FOREIGN KEY (provider_id)
        REFERENCES provider (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_prf_ide_prf FOREIGN KEY (profile_id)
        REFERENCES profile (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
    OIDS=FALSE
);

ALTER TABLE profile_identity
    OWNER TO wso2;

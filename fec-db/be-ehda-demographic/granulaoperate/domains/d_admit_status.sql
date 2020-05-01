-- Domain: admit_status

-- DROP DOMAIN admit_status;

CREATE DOMAIN admit_status
  AS character varying(20)
  COLLATE pg_catalog."default"
  NOT NULL
  CONSTRAINT admit_status_check CHECK (VALUE::text = ANY (ARRAY['preadmitted'::text, 'admitted'::text]));

ALTER DOMAIN admit_status
  OWNER TO fluance;

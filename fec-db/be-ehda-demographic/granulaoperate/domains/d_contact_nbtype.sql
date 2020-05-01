-- Domain: contact_nbtype

-- DROP DOMAIN contact_nbtype;

CREATE DOMAIN contact_nbtype
  AS character varying(20)
  COLLATE pg_catalog."default"
  CONSTRAINT contact_type_check CHECK (VALUE::text = ANY (ARRAY['answering_service_nb'::text, 'beeper_nb'::text, 'emergency_nb'::text, 'email_address'::text, 'other_residence_nb'::text, 'primary_residence_nb'::text, 'personal'::text, 'vacation_home_nb'::text, 'work_nb'::text]));

ALTER DOMAIN contact_nbtype
  OWNER TO fluance;

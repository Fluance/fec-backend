CREATE OR REPLACE FUNCTION f_unaccent(text)
  RETURNS text AS
$func$
SELECT ehealth.unaccent('ehealth.unaccent', $1)  -- schema-qualify function and dictionary
$func$  LANGUAGE sql IMMUTABLE;

ALTER FUNCTION f_unaccent(text)
  OWNER TO fluance;

CREATE EXTENSION unaccent;

GRANT EXECUTE ON FUNCTION unaccent(text) TO public;
GRANT EXECUTE ON FUNCTION unaccent(regdictionary, text) TO public;
GRANT EXECUTE ON FUNCTION unaccent_init(internal) TO public;
GRANT EXECUTE ON FUNCTION unaccent_lexize(internal, internal, internal, internal) TO public;

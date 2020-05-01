CREATE OR REPLACE FUNCTION xml_unescape(x TEXT)
RETURNS TEXT AS $BODY$

from xml.sax.saxutils import unescape
if not x: return x
else: return unescape(x)

$BODY$ LANGUAGE plpythonu IMMUTABLE;

ALTER FUNCTION xml_unescape(TEXT)
  OWNER TO fluance;

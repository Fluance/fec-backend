/*
	Function: raise_error
	Raise error.
	Call from inside another function instead of raising an error directly
	to get plpgsql to add CONTEXT (with line number) to error message.

	Parameters:
		_lvl - error level: EXCEPTION | WARNING | NOTICE | DEBUG | LOG | INFO
		_msg - error message

	Returns:
		None
*/

CREATE OR REPLACE FUNCTION raise_error(_lvl TEXT = 'EXCEPTION', _msg TEXT = 'Default error message.')
RETURNS void AS $func$

BEGIN
   CASE upper(_lvl)
      WHEN 'EXCEPTION' THEN RAISE EXCEPTION '%', _msg;
      WHEN 'WARNING'   THEN RAISE WARNING   '%', _msg;
      WHEN 'NOTICE'    THEN RAISE NOTICE    '%', _msg;
      WHEN 'DEBUG'     THEN RAISE DEBUG     '%', _msg;
      WHEN 'LOG'       THEN RAISE LOG       '%', _msg;
      WHEN 'INFO'      THEN RAISE INFO      '%', _msg;
      ELSE RAISE EXCEPTION 'raise_error(): unexpected raise-level: "%"', _lvl;
   END CASE;
END
$func$ LANGUAGE plpgsql STRICT;

ALTER FUNCTION raise_error(TEXT, TEXT)
  OWNER TO fluance;

/*
	Function: manage_visit_guarantor
	
	This function's goal is to add/update guarantors linked to a visit in operate database.

	Parameters:
		_vn  - BIGINT  visit number
		_cid - VARCHAR control_id of the hl7 data in inbound.
		_src - VARCHAR application source name.

	Returns:
		None

	See also:
		<visit>, <visit_guarantor>, <insert_visit_guarantor>
*/
CREATE FUNCTION manage_visit_guarantor (_vn BIGINT, _cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $$

DECLARE
    v_gua RECORD;

BEGIN

    IF _vn IS NULL THEN
	PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _vn');
    END IF;
    
    -- If visit nb not found, insert_visit_guarantor
    IF NOT EXISTS (SELECT 1 FROM visit_guarantor WHERE visit_nb = _vn) THEN
        PERFORM insert_visit_guarantor(_vn, _cid, _src);
    ELSE

        /*
        * Delete existing visit_guarantor and store new ones if exist
        */
	-- Create a temp table to store occasional guarantor ID
        CREATE TEMP TABLE gua_tbl AS SELECT id FROM guarantor JOIN visit_guarantor ON (guarantor_id = id) WHERE occasional = true AND visit_nb = _vn;

        -- Delete visit_guarantor except occasional guarantor
        DELETE FROM visit_guarantor WHERE visit_nb = _vn;

	-- Loop on the occasional guarantors
        FOR v_gua IN
            SELECT * FROM gua_tbl
        LOOP
            -- Delete all occasional guarantors contacts
            DELETE FROM contact WHERE id IN (SELECT contact_id FROM guarantor_contact WHERE guarantor_id = v_gua.id);
            -- Delete occasional guarantors
            DELETE FROM guarantor WHERE id = v_gua.id;
        END LOOP;

        DROP TABLE IF EXISTS gua_tbl;

	-- Add new visit_guarantor
        PERFORM insert_visit_guarantor(_vn, _cid, _src);

    END IF;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION manage_visit_guarantor (BIGINT, VARCHAR, VARCHAR)
OWNER TO fluance;

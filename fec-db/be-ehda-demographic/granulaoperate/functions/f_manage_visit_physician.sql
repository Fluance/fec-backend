/*
	Function: manage_visit_physician
	
	This function's goal is to add/update physicians linked to a visit in operate database.

	Parameters:
		_vn  - BIGINT  visit number
		_cid - VARCHAR control_id of the hl7 data in inbound.
		_src - VARCHAR application source name.

	Returns:
		None

	See also:
		<visit>, <visit_physician>, <insert_visit_physician>
*/
CREATE FUNCTION manage_visit_physician (_vn BIGINT, _cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $$

DECLARE
    v_phy RECORD;

BEGIN

    IF _vn IS NULL THEN
	PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _vn');
    END IF;
    
    -- If visit nb not found, insert_visit_physician
    IF NOT EXISTS (SELECT 1 FROM visit_physician WHERE visit_nb = _vn) THEN
        PERFORM insert_visit_physician(_vn, _cid, _src);
    ELSE

        /*
        * Delete existing physician_visit and store new ones
        */
        -- Create a temp table to store occasional physician ID
        CREATE TEMP TABLE phy_tbl AS SELECT p.id FROM physician p JOIN visit_physician vp ON (vp.attending_physician_id = p.id OR vp.referring_physician_id = p.id OR vp.consulting_physician_id= p.id OR vp.admitting_physician_id= p.id) WHERE p.occasional = true AND visit_nb = _vn;

        -- Delete all the physician for the visit
        DELETE FROM visit_physician WHERE visit_nb = _vn;

        -- Loop on the occasional physicians
        FOR v_phy IN 
	    SELECT * FROM phy_tbl
        LOOP
            -- Delete occasional physicians
            DELETE FROM physician WHERE id = v_phy.id;
        END LOOP;

        DROP TABLE IF EXISTS phy_tbl;

        -- Add new visit_physician
        PERFORM insert_visit_physician(_vn, _cid, _src);

    END IF;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION manage_visit_physician (BIGINT, VARCHAR, VARCHAR)
OWNER TO fluance;

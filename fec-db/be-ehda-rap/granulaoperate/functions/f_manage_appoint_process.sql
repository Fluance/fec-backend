/*
    Function: manage_appoint_process
        This function manage the process status for a specific appointment.

    Parameters:

        _cid  - control id of the record
        _appid - appointment_id
        _src  - source application name

    Returns:
        None

    Algo:
        (start code)
        Delete all processes for this appointement if they exist
        Insert the ones returned from inbound table
        (end code)

    See also:
        <appointment>, <process_status>, <appointment_process_status>, <fdw_rap_nte>

*/
CREATE FUNCTION manage_appoint_process (_appid BIGINT, _cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $$

DECLARE
    v_app RECORD;
    v_psid INTEGER;

BEGIN
    IF _appid IS NULL THEN
	PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _appid');
    END IF;

    -- Delete previous process
    IF EXISTS(SELECT 1 FROM appointment_process_status WHERE appoint_id = _appid)
    THEN
      DELETE FROM appointment_process_status WHERE appoint_id = _appid;
    END IF;

    -- Loop on nte segments
    FOR v_app IN
            SELECT * FROM fdw_rap_nte(_cid)
    LOOP
	SELECT id INTO v_psid FROM process_status WHERE company_id = v_app.company_id AND psid = v_app.nte_4_1;
    
	IF FOUND THEN
		-- Update the record
		UPDATE process_status SET eventcode = v_app.nte_4_4, event = v_app.nte_4_2, source = _src, sourceid = _cid
		WHERE id = v_psid;
	ELSE
		-- Insert if the status is not found
		INSERT INTO process_status (company_id, psid, eventcode, event, source, sourceid)
		VALUES (v_app.company_id, v_app.nte_4_1, v_app.nte_4_4, v_app.nte_4_2, _src, _cid) RETURNING id INTO v_psid;
	END IF;

	INSERT INTO appointment_process_status VALUES (_appid, v_psid, v_app.nte_1_1, v_app.nte_3_1);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION manage_appoint_process (BIGINT, VARCHAR, VARCHAR)
OWNER TO fluance;

/*
    Function: delete_appointment
        This function is used by mirth in the channel P_RAP* when a SUI/S17 HL7 message is received.
        Delete appointment which means update the appointment's status to deleted.

    Parameters:

        _cid - control id of the record
        _src - source application name

    Returns:


    Algo:
        (start code)
        IF (app_id) THEN
            UPDATE app_id status = deleted
        END
        (end code)

    See also:
        <appointment>, <fdw_rap_sch_ais>

*/
CREATE FUNCTION delete_appointment (_cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $$

DECLARE
    v_pp RECORD;
    v_appid BIGINT;

BEGIN

    IF (_cid <> '') IS NOT TRUE THEN
	PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
    END IF;

    SELECT * INTO v_pp FROM fdw_rap_sch_ais(_cid);

    -- Check if the appointment exists
    SELECT id INTO v_appid FROM appointment WHERE company_id = v_pp.company_id AND aid = v_pp.sch_2_1;
    
    IF FOUND THEN
	-- delete all appointment resources
	DELETE FROM appointment_resource_device WHERE appoint_id = v_appid;
	DELETE FROM appointment_resource_location WHERE appoint_id = v_appid;
	DELETE FROM appointment_resource_personnel WHERE appoint_id = v_appid;
        -- update appointment status
        UPDATE appointment SET status = v_pp.ais_10_1, source = _src, sourceid = v_pp.control_id
        WHERE id = v_appid;
    END IF;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION delete_appointment (VARCHAR, VARCHAR)
OWNER TO fluance;

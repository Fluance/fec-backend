/*
    Function: insert_appointment
        This function is used to insert appointment in granulaoperate from granulainbound (rap_hl7).

    Parameters:

        _cid - control id of the record
        _src - source application name

    Returns:
        None

    Algo:
        (start code)
        IF (vn) THEN
            INSERT appointment
            ADD resource link to this appointment
            ADD process status link to this appointment
            ADD procedure specifics link to this appointment
            ADD step durations link to this appointment
        END IF
        (end code)

    See also:
        <appointment>, <fdw_rap_sch_ais>, <manage_appoint_resource>, <manage_appoint_process>, <manage_appoint_procedure>, <manage_appoint_step_duration>
*/
CREATE FUNCTION insert_appointment (_cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $$

DECLARE
    v_pp RECORD;
    v_api RECORD;
    v_asd RECORD;
    v_appid BIGINT := NULL;

BEGIN
    IF (_cid <> '') IS NOT TRUE THEN
    PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
    END IF;

    -- Get appointment data
    SELECT * INTO v_pp FROM fdw_rap_sch_ais(_cid);
    -- Check if the visit exists
    IF EXISTS (SELECT 1 FROM visit WHERE nb = v_pp.pv1_19_1) THEN
        -- Insert new appointment
        INSERT INTO appointment (company_id, aid, agid, scheduleid, scheduledesc, visit_nb, begindt, enddt, duration, type, description, status, source, appointkindcode, appointkinddescription, sourceid) 
		VALUES (v_pp.company_id, v_pp.sch_2_1, v_pp.sch_4_1, v_pp.sch_5_1, v_pp.sch_5_2, v_pp.pv1_19_1, v_pp.sch_11_4, v_pp.sch_11_5, v_pp.sch_11_3, v_pp.ais_2_8, v_pp.ais_2_4, v_pp.ais_10_1, _src, v_pp.ais_2_1, v_pp.ais_2_2, v_pp.control_id)
		RETURNING id INTO v_appid;
	
        -- Insert/update appointment resources
        PERFORM manage_appoint_resource(v_appid, _cid, _src);
        -- Insert/update appointment processes
        PERFORM manage_appoint_process(v_appid, _cid, _src);
        -- Insert/update appointment procedures
        PERFORM manage_appoint_procedure(v_appid, _cid, _src);
        -- Insert/update appointment steps duration
        PERFORM manage_appoint_step_duration(v_appid, _cid, _src);
    ELSE
        PERFORM raise_error('EXCEPTION', 'Nonexistent VISIT NUMBER: ' || v_pp.pv1_19_1);
    END IF;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION insert_appointment (VARCHAR, VARCHAR)
OWNER TO fluance;


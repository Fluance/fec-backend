/*
    Function: update_appointment
        This function's goal is to update an already inserted appointment from rap.

    Parameters:

        _cid - control id of the record
        _src - source application name

    Returns:
        None

    Algo:
        (start code)
        If (app) THEN
            IF (vn) THEN
                update appointment
                manage_appoint_resource -- link the potential (new) resources.
                manage_appoint_process -- link the potential (new) process status.
                manage_appoint_procedure -- link the potential (new) procedure specifics.
                manage_appoint_step_duration -- link the potential (new) step durations.
            END IF
        END IF
        (end code)

    See also:
        <appointment>, <fdw_rap_sch_ais>, <manage_appoint_resource>, <manage_appoint_process>, <manage_appoint_procedure>, <manage_appoint_step_duration>
*/
CREATE FUNCTION update_appointment (_cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $$

DECLARE
    v_pp RECORD;
    v_appid BIGINT := NULL;

BEGIN
    IF (_cid <> '') IS NOT TRUE THEN
    PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
    END IF;

    -- Get appointment data
    SELECT * INTO v_pp FROM fdw_rap_sch_ais(_cid);

    -- check if the appointment exists
    SELECT id INTO v_appid FROM appointment WHERE company_id = v_pp.company_id AND aid = v_pp.sch_2_1;

    IF FOUND THEN
	    -- check if the visit still exists
        IF EXISTS (SELECT 1 FROM visit WHERE nb = v_pp.pv1_19_1) THEN
			-- Update appointment data
            UPDATE appointment SET agid = v_pp.sch_4_1, scheduleid = v_pp.sch_5_1, scheduledesc = v_pp.sch_5_2, 
                        visit_nb = v_pp.pv1_19_1, duration =  v_pp.sch_11_3,
                        begindt = v_pp.sch_11_4, enddt = v_pp.sch_11_5,
                        type = v_pp.ais_2_8, description = v_pp.ais_2_4,
                        status = v_pp.ais_10_1, source = _src,
                        appointkindcode = v_pp.ais_2_1, appointkinddescription = v_pp.ais_2_2,
                        sourceid = v_pp.control_id
            WHERE id = v_appid;

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
    ELSE
        PERFORM raise_error('EXCEPTION', 'Nonexistent APPOINTMENT ' || v_pp.sch_2_1 || ' WITH COMPANY ID ' || v_pp.company_id);
    END IF;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION update_appointment (VARCHAR, VARCHAR)
OWNER TO fluance;


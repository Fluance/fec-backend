/*
    Function: manage_appoint_resource
        This function manage the ressource(s) for a specific appointment.
        (Ex : Personnal, room reservation etc...).

    Parameters:

        _cid  - control id of the record
        _appid - appointment_id
        _src  - source application name

    Returns:
        None

    Algo:
        (start code)
        Delete all ressources for this appointement
        res = inbound.get(_appid)
        -- Start update resource data
        if (res) then
            Update resource
        else
            Insert resource
        end if
        -- end update resource data
        -- link resource to appointment
        insert into appointment_resource(ress.id, app.id)
        (end code)

    See also:
        <appointment>, <resource_personnel>, <resource_location>, <resource_device>, <appointment_resource_personnel>, <appointment_resource_location>, <appointment_resource_device>, <fdw_rap_aig>

*/
CREATE FUNCTION manage_appoint_resource (_appid BIGINT, _cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $$

DECLARE
    v_appr RECORD;
    v_rid INTEGER;

BEGIN
    IF _appid IS NULL THEN
	PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _appid');
    END IF;

    -- Delete previous link
    IF EXISTS(SELECT 1 FROM appointment WHERE id = _appid)
    THEN
      DELETE FROM appointment_resource_personnel WHERE appoint_id = _appid;
      DELETE FROM appointment_resource_location WHERE appoint_id = _appid;
      DELETE FROM appointment_resource_device WHERE appoint_id = _appid;
    END IF;

    -- Loop on aig segments
    FOR v_appr IN
            SELECT * FROM fdw_rap_aig(_cid)
    LOOP
      --Resource type O/P/G
      CASE v_appr.aig_4_1

         WHEN 'O' THEN
          SELECT id INTO v_rid FROM resource_location WHERE rsid = v_appr.aig_3_1 AND company_id = v_appr.company_id;
	  
          IF FOUND THEN
            -- Update the record
            UPDATE resource_location SET type = v_appr.aig_3_5, name = v_appr.aig_3_2, source = _src, sourceid = _cid
            WHERE id = v_rid;
          ELSE
            -- Insert if the resource is not found
            INSERT INTO resource_location (company_id, rsid, type, name, source, sourceid)
            VALUES (v_appr.company_id, v_appr.aig_3_1, v_appr.aig_3_5, v_appr.aig_3_2, _src, _cid) RETURNING id INTO v_rid;
         END IF;

            INSERT INTO appointment_resource_location (appoint_id, rl_id, begindt, duration) VALUES (_appid, v_rid, v_appr.aig_8_1, v_appr.aig_11_1);

        WHEN 'P' THEN
            SELECT id INTO v_rid FROM resource_personnel WHERE rsid = v_appr.aig_3_1 AND company_id=v_appr.company_id;

            IF FOUND THEN
              -- Update the record
              UPDATE resource_personnel SET staffid = v_appr.aig_3_3, role = v_appr.aig_3_5, name = v_appr.aig_3_2, address = v_appr.aig_3_7, address2 = v_appr.aig_3_8, postcode = v_appr.aig_3_9, locality = v_appr.aig_3_10, 
		internalphone = v_appr.aig_3_11, privatephone = v_appr.aig_3_12, altphone = v_appr.aig_3_13, fax = v_appr.aig_3_14, source = _src, sourceid = _cid
              WHERE id = v_rid;
            ELSE
              -- Insert if the resource is not found
              INSERT INTO resource_personnel (company_id, rsid, staffid, role, name, address, address2, postcode, locality, internalphone, privatephone, altphone, fax,source, sourceid)
              VALUES (v_appr.company_id, v_appr.aig_3_1, v_appr.aig_3_3, v_appr.aig_3_5, v_appr.aig_3_2, v_appr.aig_3_7, v_appr.aig_3_8, v_appr.aig_3_9, v_appr.aig_3_10, v_appr.aig_3_11, v_appr.aig_3_12, v_appr.aig_3_13, v_appr.aig_3_14, _src, _cid) RETURNING id INTO v_rid;
            END IF;

          INSERT INTO appointment_resource_personnel (appoint_id, rp_id, begindt, duration, occupationcode) VALUES (_appid, v_rid, v_appr.aig_8_1, v_appr.aig_11_1, v_appr.aig_5_4);

        WHEN 'G' THEN
          SELECT id INTO v_rid FROM resource_device WHERE rsid = v_appr.aig_3_1 AND company_id = v_appr.company_id;
	  
          IF FOUND THEN
	    -- Update the record
            UPDATE resource_device SET type = v_appr.aig_3_5, name = v_appr.aig_3_2, source = _src, sourceid = _cid
            WHERE id = v_rid;
          ELSE
	    -- Insert if the resource is not found
            INSERT INTO resource_device (company_id, rsid, type, name, source, sourceid)
            VALUES (v_appr.company_id, v_appr.aig_3_1, v_appr.aig_3_5, v_appr.aig_3_2, _src, _cid) RETURNING id INTO v_rid;
          END IF;

          INSERT INTO appointment_resource_device (appoint_id, rd_id, begindt, duration) VALUES (_appid, v_rid, v_appr.aig_8_1, v_appr.aig_11_1);

        ELSE
          PERFORM raise_error('EXCEPTION', 'Unknown resource type code: ' || v_appr.aig_4_1);

       END CASE;

    END LOOP;

END;
$$ LANGUAGE plpgsql;


ALTER FUNCTION manage_appoint_resource (BIGINT, VARCHAR, VARCHAR)
OWNER TO fluance;

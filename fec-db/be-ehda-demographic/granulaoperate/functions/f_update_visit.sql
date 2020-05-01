/*
	Function: update_visit
	This function's goal is to update the visit's data in granulaoperate database.
	- Check if the visit had already been inserted.
	- Delete all previous visit_(guarantor/physician) and also guarantor/physician in guarantor/physician tables.
	- This function is called by Mirth with the HL7 ADT event A08 (update visit) or A01/A04 after A05

	It does NOT update the fields PV1.3.1, PV1.3.2, PV1.3.3, PV1.6.1, PV1.6.2, PV1.6.3 and PV1.10.1 which are handled ONLY with the function <transfert_patient>.
	EXCEPTION: When admitstatus is preadmitted, always update those fields (A05 -> A01/A04, A05 -> A08)

	Parameters:
		_cid - BIGINT control_id of the hl7 data in inbound.
		_src - VARCHAR application source name.

	Returns:
		None

	Algo:
		(start code)
		IF (vn) THEN
			-- Update visit details
			UPDATE visit

			-- handle update of physician including occasinal physician/guarantor
			tmp store of visit_physician/visit_guarantor
			delete visit_physician/visit_guarantor occasionall
			delete occasinal-physician/guarantor from physician/guarantor table
			delete occasinal-guarantor contacts

			-- Insert new data
			manage  visit_physician/visit_guarantor
			update visit_obs_result/operation
		END IF
		(end code)

	See also:
		<visit>, <manage_visit_physician>, <manage_visit_guarantor>, <update_visit_obs_result>, <update_operation>, <fdw_demographic_pv1_pv2>
*/
CREATE OR REPLACE FUNCTION update_visit(_cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $$

DECLARE
    v_rec RECORD;
    v_gua RECORD;
    v_phy RECORD;

BEGIN
    IF (_cid <> '') IS NOT TRUE THEN
	PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
    END IF;

    -- Update visit with data from inbound db
    SELECT * INTO v_rec FROM fdw_demographic_pv1_pv2(_cid);
    
    IF FOUND THEN
	-- If visit nb not found for this pid, raise an exception
	IF NOT EXISTS (SELECT 1 FROM visit WHERE nb = v_rec.pv1_19_1 AND patient_id = v_rec.pid) THEN
		PERFORM raise_error('EXCEPTION', 'Nonexistent VISIT NUMBER ' || v_rec.pv1_19_1 || ' WITH PATIENT ID ' || v_rec.pid);
	END IF;

	-- If returned admitstatus IS NULL keep the current admitstatus (must NOT be updated)
	-- If current admitstatus = 'preadmitted' update PV1.3.1, PV1.3.2, PV1.3.3, PV1.6.1, PV1.6.2, PV1.6.3 and PV1.10.1, else keep current values
	UPDATE visit SET patientclass = v_rec.pv1_2_1, patientunit = CASE WHEN admitstatus = 'preadmitted' THEN v_rec.pv1_3_1 ELSE patientunit END, patientroom = CASE WHEN admitstatus = 'preadmitted' THEN v_rec.pv1_3_2 ELSE patientroom END,
		patientbed = CASE WHEN admitstatus = 'preadmitted' THEN v_rec.pv1_3_3 ELSE patientbed END, patientcase = v_rec.pv1_3_5, company_id = v_rec.company_id, admissiontype = v_rec.pv1_4_1,
		priorunit = CASE WHEN admitstatus = 'preadmitted' THEN v_rec.pv1_6_1 ELSE priorunit END, priorroom = CASE WHEN admitstatus = 'preadmitted' THEN v_rec.pv1_6_2 ELSE priorroom END,
		priorbed = CASE WHEN admitstatus = 'preadmitted' THEN v_rec.pv1_6_3 ELSE priorbed END, hospservice = CASE WHEN admitstatus = 'preadmitted' THEN v_rec.pv1_10_1 ELSE hospservice END,
		inactiveres = v_rec.pv1_12_1, admitsource = v_rec.pv1_14_1, patienttype = v_rec.pv1_18_1, assigningauth = v_rec.pv1_19_4, financialclass = v_rec.pv1_20_1, chargepriceind = v_rec.pv1_21_1 ,
		sequencenb = v_rec.pv1_24_1, priormvtroom = v_rec.pv1_34_1, dischargedisp = v_rec.pv1_36_1, dischargetoloc = v_rec.pv1_37_1, dischargesupp = v_rec.pv1_38_1, accountstatus = v_rec.pv1_41_1,
		priorlocation = v_rec.pv1_43_1, admitdt = v_rec.pv1_44_1, dischargedt = v_rec.pv1_45_1, patientbalance = v_rec.pv1_47_1, fid = v_rec.pv1_50_1, visitindicator = v_rec.pv1_51_1, admitreason = v_rec.pv2_3_1,
		reside = v_rec.pv2_6_1, expadmitdt = v_rec.pv2_8_1, expdischargedt = v_rec.pv2_9_1, groupingfolder = v_rec.pv2_16_1, drgsplittingdate = v_rec.pv2_17_1, chargedfolder = v_rec.pv2_18_1, groupingreason = v_rec.pv2_19_1,
		interventiondt = v_rec.pv2_33_1, freezone = v_rec.pv2_41_1, statzone1 = v_rec.pv2_12_1, statzone2 = v_rec.pv2_41_4, statzone3 = v_rec.pv2_41_5, statzone4 = v_rec.pv2_41_2, statzone5 = v_rec.pv2_41_6,
		admitstatus = CASE WHEN v_rec.admitstatus IS NOT NULL THEN v_rec.admitstatus ELSE admitstatus END, source = _src, sourceid = v_rec.control_id
	WHERE nb = v_rec.pv1_19_1;

	/*
	* Store new visit_physician
	*/
	PERFORM manage_visit_physician(v_rec.pv1_19_1, _cid, _src);

	/*
	* Store new visit_guarantor
	*/
	PERFORM manage_visit_guarantor(v_rec.pv1_19_1, _cid, _src);

	/*
	* Store observations results
	*/
	PERFORM update_visit_obs_result(v_rec.pv1_19_1, _cid, _src);

	/*
	* Store new healthcare information
	*/
	PERFORM manage_healthcare(v_rec.pv1_19_1, _cid, _src);
    END IF;
END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION update_visit(VARCHAR, VARCHAR)
  OWNER TO fluance;

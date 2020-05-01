/*
	View: bmv_patient_nextofkins_list

	View used to provide a list of next of kin for a patient

	See also:
		<nextofkin>
*/

CREATE OR REPLACE VIEW bmv_patient_nextofkins_list AS
 SELECT n.id,
	n.lastname,
	n.firstname,
	n.type,
	n.locality,
	n.country,
	n.address,
	n.address2,
	n.postcode,
	n.canton,
	n.complement,
	n.careof,
	CASE WHEN n.addresstype = '1' THEN 'mailing'
	     WHEN n.addresstype = '2' THEN 'billing'
	     WHEN n.addresstype = '3' THEN 'mailing and billing'
	END AS addresstype,
	n.patient_id
 FROM nextofkin n;

ALTER TABLE bmv_patient_nextofkins_list
  OWNER TO fluance;
/*
	View: bmv_patient_contacts_list

	View used to provide the full contacts list of a patient

	See also:
		<patient>, <patient_contact>
*/

CREATE OR REPLACE VIEW bmv_patient_contacts_list AS
 SELECT c.nbtype,
	c.equipment,
	c.data,
	p.id
 FROM patient p JOIN patient_contact pc ON (p.id = pc.patient_id) JOIN contact c ON (pc.contact_id = c.id);

ALTER TABLE bmv_patient_contacts_list
  OWNER TO fluance;
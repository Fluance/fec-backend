/*
	View: bmv_nextofkin_contacts_list

	View used to provide the full contacts list of a next of kin

	See also:
		<nextofkin>, <nextofkin_contact>
*/

CREATE OR REPLACE VIEW bmv_nextofkin_contacts_list AS
 SELECT c.nbtype,
	c.equipment,
	c.data,
	n.id
 FROM nextofkin n JOIN nextofkin_contact nc ON (n.id = nc.nextofkin_id) JOIN contact c ON (nc.contact_id = c.id);

ALTER TABLE bmv_nextofkin_contacts_list
  OWNER TO fluance;
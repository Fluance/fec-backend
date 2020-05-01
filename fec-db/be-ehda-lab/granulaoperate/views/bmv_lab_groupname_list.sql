CREATE OR REPLACE VIEW bmv_lab_groupname_list AS 
 SELECT l.groupname,
	l.patient_id,
	l.groupid
 FROM lab_obs_request l where l.groupid not in ('ÜÜ','££','98','ZA','$$','A#','ÜA');

ALTER TABLE bmv_lab_groupname_list OWNER TO fluance;

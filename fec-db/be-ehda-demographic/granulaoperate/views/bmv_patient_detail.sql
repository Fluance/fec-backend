/*
	View: bmv_patient_detail

	View used to provide the full detail of a patient

	See also:
		<patient>
*/

CREATE OR REPLACE VIEW bmv_patient_detail AS
 SELECT p.id,
	p.lastname,
	p.firstname,
	p.maidenname,
	p.birthdate,
	p.nationality,
	CASE WHEN p.sex in ('männlich', 'Masculin', 'Maschile') THEN 'M' 
    		WHEN p.sex in ('weiblich', 'Femminile', 'Féminin') THEN 'F' 
    		ELSE 'U' 
	END as sex,
	p.avsnb,
	p.locality,
	p.country,
	p.language,
	p.address,
	p.address2,
	p.postcode,
	p.subpostcode,
	p.canton,
	p.careof,
	p.complement,
	p.death,
	p.deathdt,
	p.courtesy,
	p.maritalstatus
 FROM patient p;

ALTER TABLE bmv_patient_detail
  OWNER TO fluance;

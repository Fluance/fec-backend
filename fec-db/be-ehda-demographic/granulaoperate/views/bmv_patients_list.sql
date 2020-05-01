/*
	View: bmv_patients_list

	View used to provide a full list of patients for a company

	See also:
		<patient>, <visit>, <m_rd_opa_pcl>, <m_rd_opa_pt>, <m_rd_opa_pca>, <m_rd_opa_hs>, <m_rd_opa_at>, <m_rd_opa_fcl>, <m_rd_opa_pu>
*/

CREATE OR REPLACE VIEW bmv_patients_list AS
 SELECT v.patient_id,
	p.firstname,
	p.lastname,
	p.maidenname,
	p.birthdate,
	CASE WHEN p.sex in ('männlich', 'Masculin', 'Maschile') THEN 'M' 
    		WHEN p.sex in ('weiblich', 'Femminile', 'Féminin') THEN 'F' 
    		ELSE 'U' 
	END as sex,
	p.address,
	p.postcode,
	p.locality,
        p.death,
        p.deathdt,
	v.nb,
	v.admitdt,
	v.dischargedt,
	v.patientclass,
	v.patienttype,
	v.patientcase,
	v.hospservice,
	v.admissiontype,
	v.financialclass,
	v.patientunit,
	v.patientroom,
	v.patientbed,
	v.company_id,
	patientclassdesc,
	patienttypedesc,
	patientcasedesc,
	hospservicedesc,
	admissiontypedesc,
	financialclassdesc,
	patientunitdesc,
	m_rd_opa_pcl.hl7code
 FROM patient p JOIN visit v ON (v.patient_id = p.id)
		LEFT JOIN m_rd_opa_pcl ON
                (v.patientclass = m_rd_opa_pcl.code AND v.company_id = m_rd_opa_pcl.company_id)
		LEFT JOIN m_rd_opa_pt ON
                (v.patienttype = m_rd_opa_pt.code AND v.company_id = m_rd_opa_pt.company_id)
		LEFT JOIN m_rd_opa_pca ON
                (v.patientcase =  m_rd_opa_pca.code AND v.company_id = m_rd_opa_pca.company_id)
		LEFT JOIN m_rd_opa_hs ON
                (v.hospservice = m_rd_opa_hs.code AND v.company_id = m_rd_opa_hs.company_id)
		LEFT JOIN m_rd_opa_at ON
                (v.admissiontype =  m_rd_opa_at.code AND v.company_id = m_rd_opa_at.company_id)
		LEFT JOIN m_rd_opa_fcl ON
                (v.financialclass = m_rd_opa_fcl.code AND v.company_id =  m_rd_opa_fcl.company_id)
		LEFT JOIN m_rd_opa_pu ON
                (v.patientunit = m_rd_opa_pu.code AND v.company_id = m_rd_opa_pu.company_id);

ALTER TABLE bmv_patients_list
  OWNER TO fluance;

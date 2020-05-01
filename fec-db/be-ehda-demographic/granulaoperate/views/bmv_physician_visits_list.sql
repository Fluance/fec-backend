/*
	View: bmv_physician_visits_list

	View used to provide the full detail of a physician visits

*/

CREATE OR REPLACE VIEW bmv_physician_visits_list AS
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
    ph.staffid,
    m_rd_opa_pcl.patientclassdesc,
    m_rd_opa_pt.patienttypedesc,
    m_rd_opa_pca.patientcasedesc,
    m_rd_opa_hs.hospservicedesc,
    m_rd_opa_at.admissiontypedesc,
    m_rd_opa_fcl.financialclassdesc,
    m_rd_opa_pu.patientunitdesc,
    m_rd_opa_pcl.hl7code
   FROM patient p
     JOIN visit v ON v.patient_id = p.id
     JOIN visit_physician vp ON v.nb = vp.visit_nb
     JOIN physician ph ON ((vp.attending_physician_id = ph.id) OR (vp.referring_physician_id = ph.id) OR (vp.consulting_physician_id = ph.id) OR (vp.admitting_physician_id = ph.id) AND ph.company_id = v.company_id)
     LEFT JOIN m_rd_opa_pcl ON v.patientclass::text = m_rd_opa_pcl.code::text AND v.company_id = m_rd_opa_pcl.company_id
     LEFT JOIN m_rd_opa_pt ON v.patienttype::text = m_rd_opa_pt.code::text AND v.company_id = m_rd_opa_pt.company_id
     LEFT JOIN m_rd_opa_pca ON v.patientcase::text = m_rd_opa_pca.code::text AND v.company_id = m_rd_opa_pca.company_id
     LEFT JOIN m_rd_opa_hs ON v.hospservice::text = m_rd_opa_hs.code::text AND v.company_id = m_rd_opa_hs.company_id
     LEFT JOIN m_rd_opa_at ON v.admissiontype::text = m_rd_opa_at.code::text AND v.company_id = m_rd_opa_at.company_id
     LEFT JOIN m_rd_opa_fcl ON v.financialclass::text = m_rd_opa_fcl.code::text AND v.company_id = m_rd_opa_fcl.company_id
     LEFT JOIN m_rd_opa_pu ON v.patientunit::text = m_rd_opa_pu.code::text AND v.company_id = m_rd_opa_pu.company_id;

ALTER TABLE bmv_physician_visits_list
  OWNER TO fluance;

/*
	View: bmv_patient_visits_list

	View used to provide a list of visits for a patient

	See also:
		<visit>, <m_rd_opa_pcl>, <m_rd_opa_pt>, <m_rd_opa_pca>, <m_rd_opa_at>, <m_rd_opa_pu>, <m_rd_opa_hs>, <m_rd_opa_fcl>
*/

CREATE OR REPLACE VIEW bmv_patient_visits_list AS
 SELECT v.nb,
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
	v.patient_id,
	v.company_id,
	patientclassdesc,
	patienttypedesc,
	patientcasedesc,
	hospservicedesc,
	admissiontypedesc,
	financialclassdesc,
	patientunitdesc
 FROM visit v LEFT JOIN m_rd_opa_pcl ON
		(v.patientclass = m_rd_opa_pcl.code AND v.company_id = m_rd_opa_pcl.company_id)
		LEFT JOIN m_rd_opa_pt ON
                (v.patienttype = m_rd_opa_pt.code AND v.company_id = m_rd_opa_pt.company_id)
		LEFT JOIN m_rd_opa_pca ON
                (v.patientcase =  m_rd_opa_pca.code AND v.company_id = m_rd_opa_pca.company_id)
		LEFT JOIN m_rd_opa_at ON
                (v.admissiontype =  m_rd_opa_at.code AND v.company_id = m_rd_opa_at.company_id)
		LEFT JOIN m_rd_opa_pu ON
                (v.patientunit = m_rd_opa_pu.code AND v.company_id = m_rd_opa_pu.company_id)
		LEFT JOIN m_rd_opa_hs ON
                (v.hospservice = m_rd_opa_hs.code AND v.company_id = m_rd_opa_hs.company_id)
		LEFT JOIN m_rd_opa_fcl ON
                (v.financialclass = m_rd_opa_fcl.code AND v.company_id =  m_rd_opa_fcl.company_id);

ALTER TABLE bmv_patient_visits_list
  OWNER TO fluance;

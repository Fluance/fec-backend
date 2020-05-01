/*
	View: bmv_visit_detail

	View used to provide the full detail of a visit

	See also:
		<visit_physician>, <m_rd_opa_pcl>, <m_rd_opa_pt>, <m_rd_opa_pca>, <m_rd_opa_at>, <m_rd_opa_fcl>, <m_rd_opa_pu>, <m_rd_opa_hs>, <m_rd_opa_pru>, <m_rd_opa_as>
*/

CREATE OR REPLACE VIEW bmv_visit_detail AS
 SELECT v.nb,
	v.patient_id,
	v.company_id,
	v.patientclass,
	v.patientunit,
	v.patientroom,
	v.patientbed,
	v.patientcase,
	v.admissiontype,
	v.financialclass,
	v.priorunit,
	v.priorroom,
	v.priorbed,
	v.hospservice,
	v.admitsource,
	v.patienttype,
	v.admitdt,
	v.dischargedt,
	v.expdischargedt,
	patientclassdesc,
	patienttypedesc,
	patientcasedesc,
	admissiontypedesc,
	financialclassdesc,
	patientunitdesc,
	hospservicedesc,
	priorunitdesc,
	admitsourcedesc,
        hl7code
	
 FROM visit v LEFT JOIN m_rd_opa_pcl ON
                (v.patientclass = m_rd_opa_pcl.code AND v.company_id = m_rd_opa_pcl.company_id)
            LEFT JOIN m_rd_opa_pt ON
                (v.patienttype = m_rd_opa_pt.code AND v.company_id = m_rd_opa_pt.company_id)
            LEFT JOIN m_rd_opa_pca ON
                (v.patientcase = m_rd_opa_pca.code AND v.company_id = m_rd_opa_pca.company_id)
            LEFT JOIN m_rd_opa_at ON
                (v.admissiontype = m_rd_opa_at.code AND v.company_id =  m_rd_opa_at.company_id)
	    LEFT JOIN m_rd_opa_fcl ON
                (v.financialclass = m_rd_opa_fcl.code AND v.company_id =  m_rd_opa_fcl.company_id)
            LEFT JOIN m_rd_opa_pu ON
                (v.patientunit = m_rd_opa_pu.code AND v.company_id = m_rd_opa_pu.company_id)
            LEFT JOIN m_rd_opa_hs ON
                (v.hospservice = m_rd_opa_hs.code AND v.company_id = m_rd_opa_hs.company_id)
            LEFT JOIN m_rd_opa_pru ON
                (v.priorunit = m_rd_opa_pru.code AND v.company_id = m_rd_opa_pru.company_id)
            LEFT JOIN m_rd_opa_as ON
                (v.admitsource = m_rd_opa_as.code AND v.company_id = m_rd_opa_as.company_id);

ALTER TABLE bmv_visit_detail
  OWNER TO fluance;

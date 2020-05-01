-- View: bmv_visit_benefit_detail

-- DROP VIEW bmv_visit_benefit_detail;

CREATE OR REPLACE VIEW bmv_visit_benefit_detail AS 
 SELECT vb.id,
    vb.visit_nb,
    vb.code,
    vb.benefitdt,
    vb.quantity,
    CASE vb.side
            WHEN '1' THEN 'left'
            WHEN '2' THEN 'right'    
            ELSE NULL
        END AS side,
    vb.actingdptdesc,
    vb.note,    
    paid_p.id AS pp_id,
    paid_p.firstname AS pp_firstname,
    paid_p.lastname AS pp_lastname,
    op_p.id AS op_id,
    op_p.firstname AS op_firstname,
    op_p.lastname AS op_lastname,
    lead_p.id AS lp_id,
    lead_p.firstname AS lp_firstname,
    lead_p.lastname AS lp_lastname
   FROM visit_benefit vb
     LEFT JOIN visit_benefit_physician vbp ON vbp.visit_benefit_id = vb.id
     LEFT JOIN physician paid_p ON vbp.paid_physician_id = paid_p.id
     LEFT JOIN physician op_p ON vbp.operating_physician_id = op_p.id
     LEFT JOIN physician lead_p ON vbp.lead_physician_id = lead_p.id;

ALTER TABLE bmv_visit_benefit_detail
  OWNER TO fluance;

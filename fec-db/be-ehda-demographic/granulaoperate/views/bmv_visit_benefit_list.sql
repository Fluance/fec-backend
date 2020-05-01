-- View: bmv_visit_benefit_list

-- DROP VIEW bmv_visit_benefit_list;

CREATE OR REPLACE VIEW bmv_visit_benefit_list AS 
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
    vb.note
   FROM visit_benefit vb;

ALTER TABLE bmv_visit_benefit_list
  OWNER TO fluance;

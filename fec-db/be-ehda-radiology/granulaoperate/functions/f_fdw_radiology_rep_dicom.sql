/*
    Function: fdw_radiology_rep_dicom
        This function returns a table which represents the usefull data of DICOM SR for a specific record from granulainbound radiology_dicom table.

    Parameters:
        _cid - control id of the record

    Returns:
        SQL Table

    See also:
        <radiology_dicom>
*/
CREATE FUNCTION fdw_radiology_rep_dicom (_cid VARCHAR)
RETURNS TABLE (studydt timestamp without time zone, tag00080050 varchar, tag00080090 varchar, tag00081048 varchar, tag00081050 varchar, tag00081060 varchar, 
		tag00100020 bigint, tag0020000D varchar, tag0040A491 varchar, tag0040A493 varchar, tag0040A160 text, control_id varchar, companycode varchar) AS $BODY$

BEGIN

RETURN QUERY EXECUTE
$$WITH x AS (SELECT control_id, dicom_msg AS hm FROM radiology_dicom WHERE control_id = $1)
 SELECT CAST((xpath('/dicom/tag00080020/text()', hm))[1] AS TEXT)::DATE + CAST((xpath('/dicom/tag00080030/text()', hm))[1] AS TEXT)::TIME,
    CAST((xpath('/dicom/tag00080050/text()', hm))[1] AS TEXT)::VARCHAR,
    replace(CAST((xpath('/dicom/tag00080090/text()', hm))[1] AS TEXT), '^', ' ')::VARCHAR,
    replace(CAST((xpath('/dicom/tag00081048/text()', hm))[1] AS TEXT), '^', ' ')::VARCHAR,
    replace(CAST((xpath('/dicom/tag00081050/text()', hm))[1] AS TEXT), '^', ' ')::VARCHAR,
    replace(CAST((xpath('/dicom/tag00081060/text()', hm))[1] AS TEXT), '^', ' ')::VARCHAR,
    CAST((xpath('/dicom/tag00100020/text()', hm))[1] AS TEXT)::BIGINT,
    CAST((xpath('/dicom/tag0020000D/text()', hm))[1] AS TEXT)::VARCHAR,
    CAST((xpath('/dicom/tag0040A491/text()', hm))[1] AS TEXT)::VARCHAR,
    CAST((xpath('/dicom/tag0040A493/text()', hm))[1] AS TEXT)::VARCHAR,
    CAST((xpath('/dicom/tag0040A730/item/tag0040A160/text()', hm))[1] AS TEXT),
    control_id,
    CAST((xpath('/dicom/tag00080080/text()', hm))[1] AS VARCHAR)
 FROM x$$
USING _cid;

END;
$BODY$ LANGUAGE plpgsql STABLE;

ALTER FUNCTION fdw_radiology_rep_dicom(VARCHAR)
  OWNER TO fluance;

CREATE FOREIGN TABLE tm_patient(
     patientI bigint,
     name varchar(100),
     birthdate date,
     hospitalID varchar(50),
     status int,
     sex char(1),
     otherPatientID varchar(50),
     vipStatus int,
     ts timestamp)
SERVER mysql_radiology
     OPTIONS (dbname 'radiologydb', table_name 'patient');

ALTER TABLE tm_patient
  OWNER TO fluance;

CREATE FOREIGN TABLE tm_mmel(
    elI bigint,
    elID varchar(100),
    name varchar(100),
    creatorUserI smallint,
    creatorEntityI smallint,
    creationDate timestamp,
    descriptionI bigint,
    elementType smallint,
    acquisitionDate timestamp,
    patientI bigint,
    examIndex varchar(50),
    ordPhysI bigint,
    perfPhysI bigint,
    compressionType smallint,
    compressionVersion smallint,
    modality varchar(10),
    examTypeI bigint,
    examOrientI bigint,
    xSize smallint,
    ySize smallint,
    zSize smallint,
    originalNbFiles int,
    blobSize bigint,
    url varchar(255),
    iconUrl varchar(255),
    urlBackup varchar(255),
    manufacturerModel varchar(64),
    seriesIUID varchar(64),
    seriesDescI bigint,
    studyIUID varchar(64),
    studyDescI bigint,
    status varchar(70),
    imageType varchar(64),
    reportStatus smallint,
    reportDoctor varchar(20),
    repComI bigint,
    reportDate timestamp,
    pathology varchar(150),
    referenceFrameIUID varchar(64),
    hasLinks smallint,
    contentCRC bigint,
    photometricInterpretation varchar(16),
    room varchar(50),
    filterName varchar(50),
    studyDemandNumber varchar(50),
    site varchar(20),
    technician varchar(32),
    dicomHeaderSize bigint,
    bundleFileName varchar(255),
    ts timestamp)
SERVER mysql_radiology
     OPTIONS (dbname 'radiologydb', table_name 'mmel');

ALTER TABLE tm_mmel
  OWNER TO fluance;

CREATE FOREIGN TABLE tm_mm_seriesdescription(
    seriesDescI bigint,
    seriesDescription varchar(64),
    ts timestamp)
SERVER mysql_radiology
     OPTIONS (dbname 'radiologydb', table_name 'mm_seriesdescription');

ALTER TABLE tm_mm_seriesdescription
  OWNER TO fluance;

CREATE FOREIGN TABLE tm_mm_examtype(
    examTypeI bigint,
    examType varchar(255),
    ts timestamp)
SERVER mysql_radiology
     OPTIONS (dbname 'radiologydb', table_name 'mm_examtype');

ALTER TABLE tm_mm_examtype
  OWNER TO fluance;

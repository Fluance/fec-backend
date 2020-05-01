CREATE SERVER foroperate FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '127.0.0.1', dbname 'granulaoperate', port '5432');

CREATE USER MAPPING FOR wso2 SERVER foroperate OPTIONS (user 'leech', password 'leech');

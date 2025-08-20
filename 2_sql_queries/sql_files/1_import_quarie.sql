-- IMPORT CSV TO MYSQL

CREATE TABLE upi_payment (
    date_s VARCHAR(10),
    month_s VARCHAR(10),
    rank_code INT,
    bank_code VARCHAR(10),
    upi_bank_name VARCHAR(255),
    total_volume_mn DECIMAL(15,2),
    total_approved_pct DECIMAL(5,4),
    total_decline_pct DECIMAL(5,4),
    bank_decline_pct DECIMAL(5,4),
    technical_decline_pct DECIMAL(5,4)
);

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\2025_upi_bank_payment.csv' 
INTO TABLE upi_payment
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM upi_payment;
-- ___________________________________________________________________________________________________________________________
CREATE TABLE upi_receipt ( 
    date_s VARCHAR(10),
    month_s VARCHAR(10),
    rank_code INT,
    bank_code VARCHAR(10),
    upi_bank_name VARCHAR(255),
    total_volume_mn DECIMAL(15,2),
    total_approved_pct DECIMAL(5,4),
    total_decline_pct DECIMAL(5,4),
    bank_decline_pct DECIMAL(5,4),
    technical_decline_pct DECIMAL(5,4)
);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\2025_upi_bank_receipt.csv' 
INTO TABLE upi_receipt
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM upi_receipt;


SELECT * FROM upi_payment;
SELECT * FROM upi_receipt;


-- ____________________________________________________________________________________________________________________________________________________________________________________________________________________________________
-- total_transaction_in_mn
WITH pay_data AS (
SELECT  
   bank_code,
   upi_bank_name, 
   SUM(total_volume_mn) total_volume_mn
   FROM upi_payment
GROUP BY bank_code, upi_bank_name
),
rec_data AS (
SELECT  
   bank_code,
   upi_bank_name, 
   SUM(total_volume_mn) total_volume_mn
   FROM upi_receipt
GROUP BY bank_code, upi_bank_name
)
SELECT 
   p.bank_code,
   p.upi_bank_name, 
   ROUND(p.total_volume_mn) AS pay_volume_mn,
   ROUND(r.total_volume_mn) AS rec_volume_mn,
   ROUND(p.total_volume_mn + r.total_volume_mn) AS total_transaction_mn
FROM pay_data p
JOIN rec_data r
ON p.bank_code = r.bank_code
AND p.upi_bank_name = r.upi_bank_name
ORDER BY total_transaction_mn DESC
LIMIT 10; 
 
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________________________________
-- total_approvals_in_pct

WITH pay_data AS (
SELECT  
   bank_code,
   upi_bank_name, 
   AVG(total_approved_pct) total_approved_pct
   FROM upi_payment
GROUP BY bank_code, upi_bank_name
),
rec_data AS (
SELECT  
   bank_code,
   upi_bank_name, 
   AVG(total_approved_pct) total_approved_pct
   FROM upi_receipt
GROUP BY bank_code, upi_bank_name
)
SELECT 
   p.bank_code,
   p.upi_bank_name, 
   CONCAT(ROUND((p.total_approved_pct) * 100), '%') AS pay_app_pct,
   CONCAT(ROUND((r.total_approved_pct) * 100), '%') AS rec_app_pct,
   CONCAT(ROUND(((p.total_approved_pct + r.total_approved_pct) / 2)* 100), '%') AS total_approved_pct
FROM pay_data p
JOIN rec_data r
ON p.bank_code = r.bank_code
AND p.upi_bank_name = r.upi_bank_name
ORDER BY total_approved_pct DESC
LIMIT 10;  
  
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________________________________
-- total_decline_in_pct
WITH pay_data AS (
SELECT  
   bank_code,
   upi_bank_name, 
   AVG(total_decline_pct) total_decline_pct
   FROM upi_payment
GROUP BY bank_code, upi_bank_name
),
rec_data AS (
SELECT  
   bank_code,
   upi_bank_name, 
   AVG(total_decline_pct) total_decline_pct
   FROM upi_receipt
GROUP BY bank_code, upi_bank_name
)
SELECT 
   p.bank_code,
   p.upi_bank_name, 
   CONCAT(ROUND((p.total_decline_pct) * 100), '%') AS pay_dec_pct,
   CONCAT(ROUND((r.total_decline_pct) * 100), '%') AS rec_dec_pct,
   CONCAT(ROUND(((p.total_decline_pct + r.total_decline_pct) / 2)* 100), '%') AS total_decline_pct
FROM pay_data p
JOIN rec_data r
ON p.bank_code = r.bank_code
AND p.upi_bank_name = r.upi_bank_name
ORDER BY total_decline_pct ASC
LIMIT 10;

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________________________________
-- total_bank_dec_in_pct
WITH pay_data AS (
SELECT  
   bank_code,
   upi_bank_name, 
   AVG(bank_decline_pct) bank_decline_pct
   FROM upi_payment
GROUP BY bank_code, upi_bank_name
),
rec_data AS (
SELECT  
   bank_code,
   upi_bank_name, 
   AVG(bank_decline_pct) bank_decline_pct
   FROM upi_receipt
GROUP BY bank_code, upi_bank_name
)
SELECT 
   p.bank_code,
   p.upi_bank_name, 
   CONCAT(ROUND((p.bank_decline_pct) * 100), '%') AS pay_bank_dec_pct,
   CONCAT(ROUND((r.bank_decline_pct) * 100), '%') AS rec_bank_dec_pct,
   CONCAT(ROUND(((p.bank_decline_pct + r.bank_decline_pct) / 2)* 100), '%') AS bank_decline_pct
FROM pay_data p
JOIN rec_data r
ON p.bank_code = r.bank_code
AND p.upi_bank_name = r.upi_bank_name
ORDER BY bank_decline_pct DESC
LIMIT 10;

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________________________________
-- total_technical_dec_in_pct
WITH pay_data AS (
SELECT  
   bank_code,
   upi_bank_name, 
   AVG(technical_decline_pct) technical_decline_pct
   FROM upi_payment
GROUP BY bank_code, upi_bank_name
),
rec_data AS (
SELECT  
   bank_code,
   upi_bank_name, 
   AVG(technical_decline_pct) technical_decline_pct
   FROM upi_receipt
GROUP BY bank_code, upi_bank_name
)
SELECT 
   p.bank_code,
   p.upi_bank_name, 
   CONCAT(ROUND((p.technical_decline_pct) * 100), '%') AS pay_tech_dec_pct,
   CONCAT(ROUND((r.technical_decline_pct) * 100), '%') AS rec_tech_dec_pct,
   CONCAT(ROUND(((p.technical_decline_pct + r.technical_decline_pct) / 2)* 100), '%') AS technical_decline_pct
FROM pay_data p
JOIN rec_data r
ON p.bank_code = r.bank_code
AND p.upi_bank_name = r.upi_bank_name
ORDER BY technical_decline_pct DESC
LIMIT 10;

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________________________________
-- total_transaction_analysis
WITH pay_data AS (
SELECT  
   bank_code,
   upi_bank_name,
   SUM(total_volume_mn) total_volume_mn, 
   AVG(total_approved_pct) total_approved_pct, 
   AVG(total_decline_pct) total_decline_pct, 
   AVG(bank_decline_pct) bank_decline_pct, 
   AVG(technical_decline_pct) technical_decline_pct
   FROM upi_payment
GROUP BY bank_code, upi_bank_name
),
rec_data AS (
SELECT  
   bank_code,
   upi_bank_name,
   SUM(total_volume_mn) total_volume_mn, 
   AVG(total_approved_pct) total_approved_pct, 
   AVG(total_decline_pct) total_decline_pct, 
   AVG(bank_decline_pct) bank_decline_pct, 
   AVG(technical_decline_pct) technical_decline_pct
   FROM upi_receipt
GROUP BY bank_code, upi_bank_name
)
SELECT 
   p.bank_code,
   p.upi_bank_name,
   
   ROUND(p.total_volume_mn) AS pay_volume_mn,
   ROUND(r.total_volume_mn) AS rec_volume_mn,
   ROUND((p.total_volume_mn + r.total_volume_mn)) AS total_transaction_mn,
   
   CONCAT(ROUND((p.total_approved_pct) * 100), '%') AS pay_app_pct,
   CONCAT(ROUND((r.total_approved_pct) * 100), '%') AS rec_app_pct,
   CONCAT(ROUND(((p.total_approved_pct + r.total_approved_pct) / 2)* 100), '%') AS total_approved_pct,
   
   CONCAT(ROUND((p.total_decline_pct) * 100), '%') AS pay_dec_pct,
   CONCAT(ROUND((r.total_decline_pct) * 100), '%') AS rec_dec_pct,
   CONCAT(ROUND(((p.total_decline_pct + r.total_decline_pct) / 2)* 100), '%') AS total_decline_pct,
   
   CONCAT(ROUND((p.bank_decline_pct) * 100), '%') AS pay_bank_dec_pct,
   CONCAT(ROUND((r.bank_decline_pct) * 100), '%') AS rec_bank_dec_pct,
   CONCAT(ROUND(((p.bank_decline_pct + r.bank_decline_pct) / 2)* 100), '%') AS bank_decline_pct,
   
   CONCAT(ROUND((p.technical_decline_pct) * 100), '%') AS pay_tech_dec_pct,
   CONCAT(ROUND((r.technical_decline_pct) * 100), '%') AS rec_tech_dec_pct,
   CONCAT(ROUND(((p.technical_decline_pct + r.technical_decline_pct) / 2)* 100), '%') AS technical_decline_pct
   
FROM pay_data p
JOIN rec_data r
ON p.bank_code = r.bank_code
AND p.upi_bank_name = r.upi_bank_name
ORDER BY total_transaction_mn DESC
LIMIT 10;
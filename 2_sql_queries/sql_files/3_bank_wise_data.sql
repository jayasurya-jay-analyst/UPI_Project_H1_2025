-- BANK_WISE_DATA

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
),
monthly_data AS (
    SELECT 
        pay.bank_code,
        pay.upi_bank_name,
        ROUND(SUM(CASE WHEN pay.month_s = 'January' THEN pay.total_volume_mn + rec.total_volume_mn END)) AS January,
        ROUND(SUM(CASE WHEN pay.month_s = 'February' THEN pay.total_volume_mn + rec.total_volume_mn END)) AS February,
        ROUND(SUM(CASE WHEN pay.month_s = 'March' THEN pay.total_volume_mn + rec.total_volume_mn END)) AS March,
        ROUND(SUM(CASE WHEN pay.month_s = 'April' THEN pay.total_volume_mn + rec.total_volume_mn END)) AS April,
        ROUND(SUM(CASE WHEN pay.month_s = 'May' THEN pay.total_volume_mn + rec.total_volume_mn END)) AS May,
        ROUND(SUM(CASE WHEN pay.month_s = 'June' THEN pay.total_volume_mn + rec.total_volume_mn END)) AS June,
        ROUND(SUM(pay.total_volume_mn) + SUM(rec.total_volume_mn)) AS monthly_total_volume
    FROM upi_payment pay
    INNER JOIN upi_receipt rec
        ON pay.bank_code = rec.bank_code
        AND pay.date_s = rec.date_s
    GROUP BY pay.upi_bank_name, pay.bank_code
)

SELECT 
    p.bank_code,
    p.upi_bank_name,
    
    -- Transaction volume metrics
    ROUND(p.total_volume_mn) AS pay_volume_mn,
    ROUND(r.total_volume_mn) AS rec_volume_mn,
    ROUND((p.total_volume_mn + r.total_volume_mn)) AS total_transaction_mn,
    
    -- Monthly breakdown
    m.January,
    m.February,
    m.March,
    m.April,
    m.May,
    m.June,
    m.monthly_total_volume,
    
    -- Approval percentages
    CONCAT(ROUND((p.total_approved_pct) * 100), '%') AS pay_app_pct,
    CONCAT(ROUND((r.total_approved_pct) * 100), '%') AS rec_app_pct,
    CONCAT(ROUND(((p.total_approved_pct + r.total_approved_pct) / 2)* 100), '%') AS total_approved_pct,
    
    -- Decline percentages
    CONCAT(ROUND((p.total_decline_pct) * 100), '%') AS pay_dec_pct,
    CONCAT(ROUND((r.total_decline_pct) * 100), '%') AS rec_dec_pct,
    CONCAT(ROUND(((p.total_decline_pct + r.total_decline_pct) / 2)* 100), '%') AS total_decline_pct,
    
    -- Bank decline percentages
    CONCAT(ROUND((p.bank_decline_pct) * 100), '%') AS pay_bank_dec_pct,
    CONCAT(ROUND((r.bank_decline_pct) * 100), '%') AS rec_bank_dec_pct,
    CONCAT(ROUND(((p.bank_decline_pct + r.bank_decline_pct) / 2)* 100), '%') AS bank_decline_pct,
    
    -- Technical decline percentages
    CONCAT(ROUND((p.technical_decline_pct) * 100), '%') AS pay_tech_dec_pct,
    CONCAT(ROUND((r.technical_decline_pct) * 100), '%') AS rec_tech_dec_pct,
    CONCAT(ROUND(((p.technical_decline_pct + r.technical_decline_pct) / 2)* 100), '%') AS technical_decline_pct
    
FROM pay_data p
JOIN rec_data r
    ON p.bank_code = r.bank_code
    AND p.upi_bank_name = r.upi_bank_name
JOIN monthly_data m
    ON p.bank_code = m.bank_code
    AND p.upi_bank_name = m.upi_bank_name
ORDER BY total_transaction_mn DESC
LIMIT 10;
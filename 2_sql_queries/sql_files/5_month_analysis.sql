-- monthly_analysis

SELECT 
pay.bank_code,
pay.upi_bank_name,
ROUND(SUM(CASE WHEN pay.month_s = 'January' THEN pay.total_volume_mn + rec.total_volume_mn END)) AS January,
ROUND(SUM(CASE WHEN pay.month_s = 'February' THEN pay.total_volume_mn + rec.total_volume_mn END)) AS February,
ROUND(SUM(CASE WHEN pay.month_s = 'March' THEN pay.total_volume_mn + rec.total_volume_mn END)) AS March,
ROUND(SUM(CASE WHEN pay.month_s = 'April' THEN pay.total_volume_mn + rec.total_volume_mn END)) AS April,
ROUND(SUM(CASE WHEN pay.month_s = 'May' THEN pay.total_volume_mn + rec.total_volume_mn END)) AS May,
ROUND(SUM(CASE WHEN pay.month_s = 'June' THEN pay.total_volume_mn + rec.total_volume_mn END)) AS June,
ROUND(SUM(pay.total_volume_mn) + SUM(rec.total_volume_mn)) total_volume
FROM upi_payment pay
INNER JOIN upi_receipt rec
ON pay.bank_code = rec.bank_code
AND pay.date_s = rec.date_s
GROUP BY pay.upi_bank_name, pay.bank_code
ORDER BY total_volume DESC
LIMIT 10;
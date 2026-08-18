-- IBM Telco Customer Churn analysis
-- PostgreSQL: load Telco-Customer-Churn.csv into telco_churn first.

-- 1. Overall churn
SELECT
    COUNT(*) AS customers,
    COUNT(*) FILTER (WHERE "Churn" = 'Yes') AS churned_customers,
    ROUND(100.0 * AVG(CASE WHEN "Churn" = 'Yes' THEN 1 ELSE 0 END)::numeric, 2) AS churn_pct
FROM telco_churn;

-- 2. Churn and monthly-charge exposure by contract
SELECT
    "Contract",
    COUNT(*) AS customers,
    ROUND(100.0 * AVG(CASE WHEN "Churn" = 'Yes' THEN 1 ELSE 0 END)::numeric, 2) AS churn_pct,
    ROUND(SUM(CASE WHEN "Churn" = 'Yes' THEN "MonthlyCharges" ELSE 0 END)::numeric, 2) AS monthly_charge_exposure
FROM telco_churn
GROUP BY "Contract"
ORDER BY churn_pct DESC;

-- 3. Churn by tenure band
WITH b AS (
    SELECT *,
        CASE
            WHEN "tenure" < 6 THEN '0-5 months'
            WHEN "tenure" < 12 THEN '6-11 months'
            WHEN "tenure" < 24 THEN '12-23 months'
            WHEN "tenure" < 48 THEN '24-47 months'
            ELSE '48+ months'
        END AS tenure_band
    FROM telco_churn
)
SELECT
    tenure_band,
    COUNT(*) AS customers,
    ROUND(100.0 * AVG(CASE WHEN "Churn" = 'Yes' THEN 1 ELSE 0 END)::numeric, 2) AS churn_pct
FROM b
GROUP BY tenure_band
ORDER BY MIN("tenure");

-- 4. Churn by payment method
SELECT
    "PaymentMethod",
    COUNT(*) AS customers,
    ROUND(100.0 * AVG(CASE WHEN "Churn" = 'Yes' THEN 1 ELSE 0 END)::numeric, 2) AS churn_pct
FROM telco_churn
GROUP BY "PaymentMethod"
ORDER BY churn_pct DESC;

-- 5. Observed monthly charge exposure among churned customers
SELECT
    ROUND(SUM("MonthlyCharges") FILTER (WHERE "Churn" = 'Yes')::numeric, 2) AS monthly_charge_exposure,
    ROUND(SUM("MonthlyCharges")::numeric, 2) AS total_monthly_charges,
    ROUND(100.0 * SUM("MonthlyCharges") FILTER (WHERE "Churn" = 'Yes') / NULLIF(SUM("MonthlyCharges"), 0)::numeric, 2) AS exposure_pct
FROM telco_churn;

-- 6. Highest monthly-charge churned customers
SELECT
    "customerID", "tenure", "Contract", "MonthlyCharges", "TotalCharges"
FROM telco_churn
WHERE "Churn" = 'Yes'
ORDER BY "MonthlyCharges" DESC
LIMIT 50;

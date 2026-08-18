-- Independent portfolio SQL
-- Dataset: IBM Telco Customer Churn public sample

WITH cleaned AS (
    SELECT
        "customerID" AS customer_id,
        "Contract" AS contract,
        "PaymentMethod" AS payment_method,
        "Churn" AS churn,
        "tenure" AS tenure,
        "MonthlyCharges"::numeric AS monthly_charges,
        NULLIF(TRIM("TotalCharges"::text), '')::numeric AS total_charges
    FROM telco_churn
)
SELECT
    COUNT(*) AS customers,
    COUNT(*) FILTER (WHERE churn = 'Yes') AS churned_customers,
    ROUND(100.0 * COUNT(*) FILTER (WHERE churn = 'Yes') / COUNT(*)::numeric, 2) AS churn_rate_pct,
    ROUND(SUM(monthly_charges) FILTER (WHERE churn = 'Yes')::numeric, 2) AS monthly_charges_exposed
FROM cleaned;

-- Contract-level retention risk
SELECT
    contract,
    COUNT(*) AS customers,
    COUNT(*) FILTER (WHERE churn = 'Yes') AS churned_customers,
    ROUND(100.0 * COUNT(*) FILTER (WHERE churn = 'Yes') / COUNT(*)::numeric, 2) AS churn_rate_pct,
    ROUND(SUM(monthly_charges) FILTER (WHERE churn = 'Yes')::numeric, 2) AS monthly_charges_exposed
FROM cleaned
GROUP BY contract
ORDER BY churn_rate_pct DESC;

-- Tenure bands
SELECT
    CASE
        WHEN tenure < 6 THEN '0-5 months'
        WHEN tenure < 12 THEN '6-11 months'
        WHEN tenure < 24 THEN '12-23 months'
        WHEN tenure < 48 THEN '24-47 months'
        ELSE '48+ months'
    END AS tenure_band,
    COUNT(*) AS customers,
    COUNT(*) FILTER (WHERE churn = 'Yes') AS churned_customers,
    ROUND(100.0 * COUNT(*) FILTER (WHERE churn = 'Yes') / COUNT(*)::numeric, 2) AS churn_rate_pct
FROM cleaned
GROUP BY 1
ORDER BY MIN(tenure);

-- Payment method comparison
SELECT
    payment_method,
    COUNT(*) AS customers,
    ROUND(100.0 * COUNT(*) FILTER (WHERE churn = 'Yes') / COUNT(*)::numeric, 2) AS churn_rate_pct,
    ROUND(SUM(monthly_charges) FILTER (WHERE churn = 'Yes')::numeric, 2) AS monthly_charges_exposed
FROM cleaned
GROUP BY payment_method
ORDER BY churn_rate_pct DESC;

# Customer Churn & Revenue Risk

## Business objective

Identify customer segments associated with churn and quantify the observed monthly recurring-charge exposure associated with churned customers.

## Dataset provenance

This project uses the **Telco Customer Churn** dataset distributed in IBM's public `telco-customer-churn-on-icp4d` repository.

**Original data source:** IBM public sample dataset repository.

> The customer records are public sample data. The SQL transformations, segmentation logic, exposure metric, analysis, and recommendations in this repository are independent portfolio work.

## Originality

This repository is independently structured and does not reproduce another analyst's SQL, notebook, README, or conclusions.

## Questions

- Which contract and tenure groups have the highest churn?
- Which customer characteristics are associated with churn?
- How is observed monthly-charge exposure distributed across churned segments?
- Which segments deserve retention attention first?

## Interpretation boundary

`monthly_revenue_at_risk` means monthly charges associated with customers who are already labeled as churned in the sample. It is **not** a predictive forecast of future revenue loss.

## Stack

SQL · Python · Power BI

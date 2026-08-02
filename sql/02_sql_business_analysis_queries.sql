-- ============================================================
-- Project: Salesforce Adoption & User Engagement Dashboard
-- File: 02_sql_business_analysis_queries.sql
-- Purpose: Final SQL analysis queries used for KPIs, charts, and insights
-- ============================================================

USE salesforce_adoption;

-- 1. Executive KPI Summary
-- Purpose: Used for KPI cards in Tableau.
SELECT
    ROUND(SUM(usage_value), 2) AS total_usage,
    ROUND(AVG(engagement), 2) AS avg_engagement,
    COUNT(DISTINCT user_id) AS active_users,
    COUNT(DISTINCT customer_name) AS total_customers,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(discount), 4) AS avg_discount,
    ROUND(SUM(adoption_score), 2) AS total_adoption_score
FROM vw_salesforce_adoption_clean;

-- 2. Region-wise Adoption Performance
-- Purpose: Compares adoption performance across regions.
SELECT
    region,
    ROUND(SUM(usage_value), 2) AS total_usage,
    ROUND(AVG(engagement), 2) AS avg_engagement,
    COUNT(DISTINCT user_id) AS active_users,
    COUNT(DISTINCT customer_name) AS total_customers,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(discount), 4) AS avg_discount,
    ROUND(SUM(adoption_score), 2) AS total_adoption_score
FROM vw_salesforce_adoption_clean
GROUP BY region
ORDER BY total_usage DESC;

-- 3. Monthly Adoption Trend
-- Purpose: Shows month-by-month usage trend for Tableau line chart.
SELECT
    activity_month,
    COUNT(*) AS activity_records,
    ROUND(SUM(usage_value), 2) AS total_usage,
    ROUND(AVG(engagement), 2) AS avg_engagement,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(adoption_score), 2) AS total_adoption_score
FROM vw_salesforce_adoption_clean
GROUP BY activity_month
ORDER BY activity_month;

-- 4. Yearly Adoption Trend
-- Purpose: Shows annual adoption growth and performance.
SELECT
    activity_year,
    COUNT(*) AS activity_records,
    ROUND(SUM(usage_value), 2) AS total_usage,
    ROUND(AVG(engagement), 2) AS avg_engagement,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(discount), 4) AS avg_discount,
    ROUND(SUM(adoption_score), 2) AS total_adoption_score
FROM vw_salesforce_adoption_clean
GROUP BY activity_year
ORDER BY activity_year;

-- 5. Training Need by Region
-- Purpose: Identifies which regions need training support.
SELECT
    region,
    COUNT(*) AS total_activity_records,
    SUM(CASE WHEN training_flag = 'Needs Training' THEN 1 ELSE 0 END) AS needs_training_records,
    ROUND(
        SUM(CASE WHEN training_flag = 'Needs Training' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS needs_training_percentage
FROM vw_salesforce_adoption_clean
GROUP BY region
ORDER BY needs_training_percentage DESC;

-- 6. Training Need by Subscription Type
-- Purpose: Finds which modules/subscription types need enablement.
SELECT
    subscription_type,
    COUNT(*) AS total_activity_records,
    SUM(CASE WHEN training_flag = 'Needs Training' THEN 1 ELSE 0 END) AS needs_training_records,
    ROUND(
        SUM(CASE WHEN training_flag = 'Needs Training' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS needs_training_percentage
FROM vw_salesforce_adoption_clean
GROUP BY subscription_type
ORDER BY needs_training_percentage DESC;

-- 7. Subscription Type Performance
-- Purpose: Compares module usage and engagement.
SELECT
    subscription_type,
    COUNT(*) AS total_activity_records,
    ROUND(SUM(usage_value), 2) AS total_usage,
    ROUND(AVG(engagement), 2) AS avg_engagement,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(discount), 4) AS avg_discount,
    ROUND(SUM(adoption_score), 2) AS total_adoption_score
FROM vw_salesforce_adoption_clean
GROUP BY subscription_type
ORDER BY total_usage DESC;

-- 8. Top 10 Subscription Types by Usage
-- Purpose: Used for dashboard-friendly Top 10 chart.
SELECT
    subscription_type,
    ROUND(SUM(usage_value), 2) AS total_usage,
    ROUND(AVG(engagement), 2) AS avg_engagement,
    ROUND(SUM(profit), 2) AS total_profit
FROM vw_salesforce_adoption_clean
GROUP BY subscription_type
ORDER BY total_usage DESC
LIMIT 10;

-- 9. Customer Profitability Analysis
-- Purpose: Compares customer usage with profitability.
SELECT
    customer_name,
    industry,
    segment,
    COUNT(*) AS activity_records,
    ROUND(SUM(usage_value), 2) AS total_usage,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(usage_value), 0), 4) AS profit_per_usage,
    ROUND(AVG(discount), 4) AS avg_discount,
    ROUND(AVG(engagement), 2) AS avg_engagement,
    ROUND(SUM(adoption_score), 2) AS total_adoption_score
FROM vw_salesforce_adoption_clean
GROUP BY
    customer_name,
    industry,
    segment
ORDER BY profit_per_usage ASC;

-- 10. High Usage but Low/Negative Profit Customers
-- Purpose: Finds commercial risk accounts.
SELECT
    customer_name,
    industry,
    segment,
    COUNT(*) AS activity_records,
    ROUND(SUM(usage_value), 2) AS total_usage,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(discount), 4) AS avg_discount,
    ROUND(AVG(engagement), 2) AS avg_engagement,
    ROUND(SUM(adoption_score), 2) AS total_adoption_score
FROM vw_salesforce_adoption_clean
GROUP BY
    customer_name,
    industry,
    segment
HAVING
    SUM(usage_value) > 20000
    AND SUM(profit) < 1000
ORDER BY total_usage DESC;

-- 11. Customer Risk Category Summary
-- Purpose: Buckets customers into actionable risk/value groups.
SELECT
    customer_risk_category,
    COUNT(*) AS customer_count
FROM (
    SELECT
        customer_name,
        CASE
            WHEN SUM(usage_value) > 20000 AND SUM(profit) < 0 THEN 'High Usage - Negative Profit'
            WHEN SUM(usage_value) > 20000 AND SUM(profit) >= 0 THEN 'High Value Customer'
            WHEN SUM(usage_value) < 5000 THEN 'Low Adoption Customer'
            ELSE 'Moderate Customer'
        END AS customer_risk_category
    FROM vw_salesforce_adoption_clean
    GROUP BY customer_name
) AS customer_summary
GROUP BY customer_risk_category
ORDER BY customer_count DESC;

-- 12. Segment-wise Adoption Performance
-- Purpose: Compares adoption across customer segments.
SELECT
    segment,
    COUNT(*) AS activity_records,
    ROUND(SUM(usage_value), 2) AS total_usage,
    ROUND(AVG(engagement), 2) AS avg_engagement,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(discount), 4) AS avg_discount,
    ROUND(SUM(adoption_score), 2) AS total_adoption_score
FROM vw_salesforce_adoption_clean
GROUP BY segment
ORDER BY total_usage DESC;

-- 13. Industry-wise Adoption Performance
-- Purpose: Identifies industries leading adoption.
SELECT
    industry,
    COUNT(*) AS activity_records,
    ROUND(SUM(usage_value), 2) AS total_usage,
    ROUND(AVG(engagement), 2) AS avg_engagement,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(discount), 4) AS avg_discount,
    ROUND(SUM(adoption_score), 2) AS total_adoption_score
FROM vw_salesforce_adoption_clean
GROUP BY industry
ORDER BY total_usage DESC;

-- 14. Region and Training Flag Summary
-- Purpose: Compares healthy vs training-needed activity by region.
SELECT
    region,
    training_flag,
    COUNT(*) AS activity_records,
    ROUND(SUM(usage_value), 2) AS total_usage,
    ROUND(AVG(engagement), 2) AS avg_engagement,
    ROUND(SUM(profit), 2) AS total_profit
FROM vw_salesforce_adoption_clean
GROUP BY
    region,
    training_flag
ORDER BY
    region,
    training_flag;

-- 15. Activity Risk Category Summary
-- Purpose: Summarizes records by adoption/commercial risk.
SELECT
    activity_risk_category,
    COUNT(*) AS activity_records,
    ROUND(SUM(usage_value), 2) AS total_usage,
    ROUND(AVG(engagement), 2) AS avg_engagement,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(adoption_score), 2) AS total_adoption_score
FROM vw_salesforce_adoption_clean
GROUP BY activity_risk_category
ORDER BY activity_records DESC;

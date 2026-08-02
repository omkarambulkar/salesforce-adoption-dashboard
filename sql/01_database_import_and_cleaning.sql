-- ============================================================
-- Project: Salesforce Adoption & User Engagement Dashboard
-- File: 01_database_import_and_cleaning.sql
-- Purpose: Database setup, CSV import, data validation, cleaned view, Tableau-ready view
-- ============================================================

CREATE DATABASE IF NOT EXISTS salesforce_adoption;
USE salesforce_adoption;

DROP TABLE IF EXISTS salesforce_usage;

CREATE TABLE salesforce_usage (
    row_id INT,
    order_id VARCHAR(50),
    activity_date_text VARCHAR(20),
    date_key INT,
    user_name VARCHAR(100),
    country VARCHAR(100),
    city VARCHAR(100),
    region VARCHAR(50),
    subregion VARCHAR(100),
    customer_name VARCHAR(150),
    user_id INT,
    industry VARCHAR(100),
    segment VARCHAR(50),
    subscription_type VARCHAR(100),
    license_id VARCHAR(50),
    usage_value DECIMAL(12,4),
    engagement INT,
    discount DECIMAL(12,4),
    profit DECIMAL(12,4)
);

-- Check table structure
DESC salesforce_usage;

-- Check MySQL import folder
SHOW VARIABLES LIKE 'secure_file_priv';

-- Import CSV file
-- Place the CSV inside the secure_file_priv folder before running this.
-- Update the file name if your CSV file name is different.
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/SaaS-Sales_Omkara_Copy.csv'
INTO TABLE salesforce_usage
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    row_id,
    order_id,
    activity_date_text,
    date_key,
    user_name,
    country,
    city,
    region,
    subregion,
    customer_name,
    user_id,
    industry,
    segment,
    subscription_type,
    license_id,
    usage_value,
    engagement,
    discount,
    profit
);

-- Validate imported rows
SELECT COUNT(*) AS total_rows
FROM salesforce_usage;

-- Preview raw data
SELECT *
FROM salesforce_usage
LIMIT 20;

-- Region-wise raw record count
SELECT
    region,
    COUNT(*) AS row_count
FROM salesforce_usage
GROUP BY region
ORDER BY row_count DESC;

-- Distinct count validation
SELECT
    COUNT(DISTINCT user_id) AS total_users,
    COUNT(DISTINCT customer_name) AS total_customers,
    COUNT(DISTINCT country) AS total_countries,
    COUNT(DISTINCT region) AS total_regions,
    COUNT(DISTINCT subscription_type) AS total_subscription_types
FROM salesforce_usage;

-- Create cleaned view
CREATE OR REPLACE VIEW vw_salesforce_adoption_clean AS
SELECT
    row_id,
    order_id,
    STR_TO_DATE(activity_date_text, '%d-%m-%Y') AS activity_date,
    YEAR(STR_TO_DATE(activity_date_text, '%d-%m-%Y')) AS activity_year,
    DATE_FORMAT(STR_TO_DATE(activity_date_text, '%d-%m-%Y'), '%Y-%m') AS activity_month,
    user_name,
    country,
    city,
    region,
    subregion,
    customer_name,
    user_id,
    industry,
    segment,
    subscription_type,
    license_id,
    usage_value,
    engagement,
    discount,
    profit,
    ROUND(usage_value * engagement, 2) AS adoption_score,
    CASE
        WHEN engagement >= 4 THEN 'High Engagement'
        WHEN engagement >= 3 THEN 'Medium Engagement'
        ELSE 'Low Engagement'
    END AS engagement_category,
    CASE
        WHEN engagement < 3 THEN 'Needs Training'
        ELSE 'Healthy'
    END AS training_flag,
    CASE
        WHEN engagement < 3 THEN 'Adoption Risk'
        WHEN usage_value > 500 AND profit >= 0 THEN 'High Value Activity'
        ELSE 'Review Needed'
    END AS activity_risk_category
FROM salesforce_usage;

-- Validate cleaned view
SELECT COUNT(*) AS total_rows
FROM vw_salesforce_adoption_clean;

SELECT *
FROM vw_salesforce_adoption_clean
LIMIT 20;

-- Create Tableau-ready view
CREATE OR REPLACE VIEW vw_tableau_salesforce_adoption_dashboard AS
SELECT
    row_id,
    order_id,
    activity_date,
    activity_year,
    activity_month,
    user_name,
    country,
    city,
    region,
    subregion,
    customer_name,
    user_id,
    industry,
    segment,
    subscription_type,
    license_id,
    usage_value,
    engagement,
    discount,
    profit,
    adoption_score,
    engagement_category,
    training_flag,
    activity_risk_category
FROM vw_salesforce_adoption_clean;

-- Validate Tableau-ready view
SELECT COUNT(*) AS total_rows
FROM vw_tableau_salesforce_adoption_dashboard;

SELECT *
FROM vw_tableau_salesforce_adoption_dashboard
LIMIT 20;

-- Export Tableau-ready data to CSV with headers
-- Before running:
-- 1. Close the CSV if it is open in Excel.
-- 2. Delete the old export file if it already exists.
-- 3. Make sure the path matches your MySQL secure_file_priv folder.

SELECT *
FROM (
    SELECT
        'row_id' AS row_id,
        'order_id' AS order_id,
        'activity_date' AS activity_date,
        'activity_year' AS activity_year,
        'activity_month' AS activity_month,
        'user_name' AS user_name,
        'country' AS country,
        'city' AS city,
        'region' AS region,
        'subregion' AS subregion,
        'customer_name' AS customer_name,
        'user_id' AS user_id,
        'industry' AS industry,
        'segment' AS segment,
        'subscription_type' AS subscription_type,
        'license_id' AS license_id,
        'usage_value' AS usage_value,
        'engagement' AS engagement,
        'discount' AS discount,
        'profit' AS profit,
        'adoption_score' AS adoption_score,
        'engagement_category' AS engagement_category,
        'training_flag' AS training_flag,
        'activity_risk_category' AS activity_risk_category
    UNION ALL
    SELECT
        CAST(row_id AS CHAR),
        order_id,
        CAST(activity_date AS CHAR),
        CAST(activity_year AS CHAR),
        activity_month,
        user_name,
        country,
        city,
        region,
        subregion,
        customer_name,
        CAST(user_id AS CHAR),
        industry,
        segment,
        subscription_type,
        license_id,
        CAST(usage_value AS CHAR),
        CAST(engagement AS CHAR),
        CAST(discount AS CHAR),
        CAST(profit AS CHAR),
        CAST(adoption_score AS CHAR),
        engagement_category,
        training_flag,
        activity_risk_category
    FROM vw_tableau_salesforce_adoption_dashboard
) AS export_data
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/tableau_salesforce_adoption_dashboard_full.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

# Salesforce Adoption & User Engagement Dashboard

## Project Overview

This project analyzes Salesforce adoption, user engagement, training needs, customer profitability, and industry-wise adoption patterns using SQL and Tableau.

The objective of this project was to understand how users, customers, regions, industries, and subscription types are engaging with a Salesforce-based SaaS solution, and to identify areas where business teams should focus adoption support, training, and commercial review.

This project was created as a data analyst portfolio project to demonstrate SQL data preparation, business analysis, Tableau dashboard development, and insight generation.

---

## Live Dashboard

Tableau Public Dashboard: https://public.tableau.com/app/profile/omkar.ambulkar/viz/Salesforce_Adoption_Dashboard_Omkar/SalesforceAdoptionDashboard

---

## Dashboard Demo Video

A short demo video has been created to show the dashboard interactivity, including filters, chart updates, and tooltips.

YouTube Demo Video: https://youtu.be/G7NbGqkcIK8

---

## Business Problem

In a Salesforce-based SaaS deployment environment, business stakeholders need visibility into:

- Which regions are adopting the platform better
- Whether usage is improving over time
- Which users or regions need training support
- Which subscription types/modules are used the most
- Whether high-usage customers are also profitable
- Which industries and segments are contributing most to adoption

The dashboard helps convert raw activity data into actionable adoption and business insights.

---

## Business Requirements

The dashboard was designed to answer the following questions:

1. Which region has the highest Salesforce usage?
2. How is adoption changing month by month?
3. Which regions have the highest training need?
4. Which subscription types are driving usage?
5. Are high-usage customers also generating positive profit?
6. Which industries are leading adoption?
7. How do usage, engagement, profit, discount, and adoption score vary across business dimensions?

---

## Tools & Technologies Used

- MySQL Workbench
- Tableau Public
- Microsoft Excel / CSV
- GitHub
- YouTube for dashboard demo video hosting

---

## Dataset

The dataset contains Salesforce/SaaS adoption-related activity records with fields such as:

- Activity Date
- User Name
- User ID
- Country
- Region
- Subregion
- Customer Name
- Industry
- Segment
- Subscription Type
- License ID
- Usage Value
- Engagement
- Discount
- Profit
- Adoption Score
- Training Flag
- Activity Risk Category

The final Tableau-ready dataset contains 9,994 records.

---

## SQL Work Performed

SQL was used for data import, validation, cleaning, transformation, and business analysis.

Key SQL tasks included:

- Creating the project database
- Creating the raw usage table
- Importing CSV data into MySQL
- Validating imported row counts
- Creating a cleaned SQL view
- Creating calculated fields such as adoption score, engagement category, training flag, and activity risk category
- Performing KPI-level analysis
- Performing region-wise, time-wise, subscription-wise, customer-wise, segment-wise, and industry-wise analysis
- Exporting the final Tableau-ready view to CSV

---

## Important SQL Concepts Used

| SQL Concept | Purpose |
|---|---|
| CREATE DATABASE | Created a dedicated project database |
| CREATE TABLE | Defined table structure and data types |
| LOAD DATA INFILE | Imported CSV data into MySQL |
| SELECT | Retrieved required data |
| COUNT | Counted rows and activity records |
| COUNT DISTINCT | Counted unique users and customers |
| SUM | Calculated total usage, profit, and adoption score |
| AVG | Calculated average engagement and average discount |
| ROUND | Formatted numeric outputs |
| GROUP BY | Aggregated data by region, month, customer, segment, and industry |
| ORDER BY | Sorted output for ranking and comparison |
| CASE WHEN | Created business categories such as training flag and risk category |
| HAVING | Filtered aggregated results |
| DATE_FORMAT | Created month-level trend fields |
| YEAR | Extracted year from activity date |
| NULLIF | Prevented division by zero |
| CREATE OR REPLACE VIEW | Created clean and Tableau-ready views |

---

## Tableau Dashboard Components

The Tableau dashboard includes the following KPI cards and charts:

### KPI Cards

- Total Usage
- Average Engagement
- Active Users
- Total Customers
- Total Profit
- Average Discount
- Adoption Score

### Charts Used

| Chart | Chart Type | Purpose |
|---|---|---|
| Region-wise Adoption Performance | Bar Chart | Compare total usage across regions |
| Monthly Adoption Trend | Line Chart | Track adoption movement over time |
| Training Need by Region | Bar Chart | Identify regions requiring training support |
| Subscription Type Performance | Horizontal Bar Chart | Compare usage across subscription types/modules |
| Customer Profitability Analysis | Scatter Plot | Identify high-usage but low-profit customers |
| Industry Adoption Performance | Horizontal Bar Chart | Compare adoption across industries |

---

## Why These Chart Types Were Used

- Bar charts were used for comparing categories such as region, training need, subscription type, and industry.
- A line chart was used for monthly adoption trend because time-series movement is best shown through a line chart.
- A scatter plot was used for customer profitability because it helps compare the relationship between total usage and total profit.
- KPI cards were used to provide a quick executive summary of overall adoption performance.

---

## Dashboard Interactivity

The dashboard includes filters for:

- Region
- Segment

These filters allow users to dynamically analyze adoption performance for specific regions and customer segments.

The dashboard also includes interactive tooltips that show additional details such as:

- Total Usage
- Average Engagement
- Total Profit
- Average Discount
- Adoption Score
- Training Need Percentage
- Needs Training Records

---

## Key Insights

- EMEA leads in total usage and adoption score, indicating strong adoption volume.
- AMER has the highest training need percentage, making it a priority for enablement and training support.
- APJ has the lowest usage volume and may require adoption improvement focus.
- Monthly usage shows visible spikes, suggesting adoption may be influenced by rollout cycles, onboarding waves, or project activity periods.
- Some customers show high usage but low or negative profit, indicating possible commercial risk or pricing review opportunities.
- Finance leads adoption by usage volume, while engagement quality varies across industries.
- Subscription type analysis helps identify which modules are driving usage and which may require additional training support.

---

## Business Impact

This dashboard can help business stakeholders:

- Monitor Salesforce adoption across regions
- Identify low-adoption or high-training-need areas
- Prioritize user enablement efforts
- Track adoption trends over time
- Review customer profitability against usage
- Identify strong and weak performing industries or subscription types
- Support data-driven decisions for training, customer success, and commercial review

---

## Project Documents

- [One-page project summary](docs/Salesforce_Adoption_Dashboard_One_Page_Project_Summary.docx)
---

## Repository Structure

```text
salesforce-adoption-dashboard/
│
├── README.md
│
├── docs/
│   ├── Salesforce_Adoption_Dashboard_One_Page_Project_Summary.docx
│   └── Salesforce_Adoption_Dashboard_Detailed_Interview_Preparation_Guide.docx
│
├── data/
│   └── tableau_salesforce_adoption_dashboard_full.csv
│
├── sql/
│   ├── 01_database_import_and_cleaning.sql
│   └── 02_sql_business_analysis_queries.sql
│
├── dashboard demo video/
│   └──  https://youtu.be/G7NbGqkcIK8
│
└── tableau/
    └── tableau_public_link.txt

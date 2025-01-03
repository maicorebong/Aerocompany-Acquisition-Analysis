# Proposal Documentation

## Introduction
This project is based on the case study from the 2024 ASCM Case Competition, which integrates elements of both merger & acquisition and supply chain management. Currently, the client, Capital Group Precision (CGP), an aeronautical parts manufacturer. faces a cash flow crisis, deteriorating customer confidence, and operational inefficiencies that threaten its viability and ability to meet lender obligations.

The primary focus is on developing and executing an immediate supply chain turnaround strategy for the client. This strategy seeks to enhance operational performance and financial stability while securing the bank's confidence as a financier and avoiding bankruptcy or a fire-sale scenario. As third-party consultants, our objective is to provide actionable recommendations for CGP's future direction. Comprehensive analyses have been undertaken to evaluate the company's current health, identify marketable operational strengths, assess its valuation, and outline strategic next steps.

To uphold confidentiality, customer names have been anonymized and replaced with fictional aeronautical companies. Additionally, the dataset itself will not be uploaded. Findings will instead comprise SQL scripts, results tables, and Power BI charts presenting aggregated data to deliver a clear and concise summary of the analyses conducted.

## Technologies
- Database and GUI: MySQL Workbench
- Data Visualization: Power BI

## Data Architecture
<img width="809" alt="workflow" src="https://github.com/user-attachments/assets/f6da143b-8e60-42f8-bddf-a1e8dcde4755" />

1. Data (transaction history and inventory list) were provided by client via CSV
2. Flat files were imported to MySQL Workbench for feature engineering and exploratory data analysis
3. Analyses were done and generated as tables
4. Only aggregated tables were fed to Power BI via MySQL ODBC API, maintaining dashboard performance and avoid overloading visuals

## 📌 Analysis

### 1. Which materials are our revenue drivers based on ABC analysis?

### 1. Who are our high-value customers?
````sql
CREATE TABLE customer_profitability AS
SELECT
    t.customer AS customer_name,
    ROUND(SUM(t.revenue), 2) AS total_revenue,
    ROUND(SUM(t.profit_or_loss), 2) AS total_profit,
    ROUND((SUM(t.profit_or_loss) / NULLIF(SUM(t.revenue), 0)) * 100.0, 2) AS profit_margin_percentage,
    ROUND(SUM(i.value_of_inv_onhand), 2) AS inventory_holding_cost,
    COUNT(DISTINCT i.part_number) AS distinct_products_sold
FROM transactions_sales t
LEFT JOIN inventory i
ON t.customer = i.customer_name
GROUP BY t.customer
ORDER BY total_revenue DESC;
````
**Answer:**
![image](https://github.com/user-attachments/assets/ed50def4-1076-4f83-981a-1ae7ae022047)
![image](https://github.com/user-attachments/assets/ac6382b3-9ca5-431b-925f-4df152022f24)

Eclipse Aerologics and Skyward Aeronautics are our top two customers, each contributing more than 45% of the company's revenue. Of the two, Eclipse Aerologics provides larger profit margins with lower holding costs for frequently ordered products.


# Proposal Documentation

## Introduction
This project is based on the case study from the 2024 ASCM Case Competition, which integrates elements of both merger & acquisition and supply chain management. Currently, the client, Capital Group Precision (CGP), an aeronautical parts manufacturer. faces a cash flow crisis, deteriorating customer confidence, and operational inefficiencies that threaten its viability and ability to meet lender obligations.

The primary focus is on developing and executing an immediate supply chain turnaround strategy for the client. This strategy seeks to enhance operational performance and financial stability while securing the bank's confidence as a financier and avoiding bankruptcy or a fire-sale scenario. As third-party consultants, our objective is to provide actionable recommendations for CGP's future direction. Comprehensive analyses have been undertaken to evaluate the company's current health, identify marketable operational strengths, assess its valuation, and outline strategic next steps.

To uphold confidentiality, customer names have been anonymized and replaced with fictional aeronautical companies. Additionally, the dataset itself will not be uploaded. Findings will instead comprise SQL scripts, results tables, and Power BI charts presenting aggregated data to deliver a clear and concise summary of the analyses conducted.

## Proposed Consulting Strategy
- Create an analysis to assess current fiscal and inventory health
- Strategy should consider impact on customers, suppliers, and stakeholders
- Focus on quick wins to generate cash flow and stabilize supply chain
- Position CGP to better market themselves for acquisition and long-term success

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
### 📊 Link to published [Power BI dashboard](https://app.powerbi.com/view?r=eyJrIjoiNDJiNTI3ZjgtN2FlZC00OGE1LWFjMmItMTNmMzY5ODRkNWFkIiwidCI6ImNmYWQ4MGQzLTZiYTAtNDU4Ny1hMGUzLTE3Mzg1YzE0ZTZlNiIsImMiOjZ9) 

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

![image](https://github.com/user-attachments/assets/32400374-9ebe-4b53-a468-9623cfc7881f)

Eclipse Aerologics and Skyward Aeronautics are our top two customers, each contributing more than 45% of the company's revenue. Of the two, Eclipse Aerologics provides larger profit margins with lower holding costs for frequently ordered products.

**Recommendation:**
- Secure long-term contracts with Eclipse Aerologics and optimize production for frequently ordered products with low holding costs.
- Promote higher-margin products with Skyward Aeronautics Relationship.


### 2. How does each material contribute to the total revenue percentage?
````sql
CREATE TABLE material_contribution_margin AS
SELECT
    year AS transaction_year,
    material,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(revenue) * 100.0 / 
          (SELECT SUM(revenue) FROM transactions_sales WHERE year = t.year), 2) AS revenue_percentage
FROM transactions_sales t
GROUP BY year, material
ORDER BY transaction_year, total_revenue DESC;
````

**Answer:**

![image](https://github.com/user-attachments/assets/7d7dd2f2-9b49-413d-b801-ffbf142ff387)

![image](https://github.com/user-attachments/assets/b14e8fa8-cb2c-4875-a841-a7e94b22095a)

Aluminum Alloy and Hard Steel are the top revenue drivers, but Hard Steel’s share has grown significantly from 32.67% in 2022 to 44.64% in 2024, while Aluminum Alloy’s contribution has declined. Meanwhile, materials like Titanium and Stainless Steel have shown minimal and consistent contributions. This trend highlights an increasing reliance on Hard Steel which creates room for strategic focus or diversification.

**Recommendation:**
- With increasing reliance on Hard Steel, explore strategic focus or diversification to increase sales opportunities.

### 3. How do turnover rates for key materials impact operational efficiency?
````sql
CREATE TABLE yearly_turnover AS
SELECT
    i.year AS inventory_year,
    i.material AS inventory_material,
    SUM(i.inv_oh) AS total_inventory_on_hand,
    ROUND(SUM(i.value_of_inv_onhand), 2) AS total_holding_cost,
    ROUND(SUM(t.revenue), 2) AS total_revenue,
    ROUND(SUM(t.revenue) / NULLIF(SUM(i.value_of_inv_onhand), 0), 2) AS turnover_ratio,
    ROUND(SUM(t.profit_or_loss), 2) AS total_transaction_profit
FROM inventory i
LEFT JOIN transactions_sales t
ON i.material = t.material
AND i.year = t.year
GROUP BY i.year, i.material
ORDER BY i.year, turnover_ratio DESC;
````
**Answer:**

![image](https://github.com/user-attachments/assets/40abf170-ef62-4328-bb1c-8574818e1d25)

![image](https://github.com/user-attachments/assets/4404cc0f-ef7b-4679-9fb0-a89915382f44)


Revenue has grown from $701M in 2022 to $1.9B in 2024, driven by Aluminum Alloy and Hard Steel. Holding costs and the % HC-to-Revenue ratio have increased, while inventory turnover has declined from 33.85% to 13.60%, indicating slower inventory movement.

**Recommendation:**
- Streamline storage and carrying processes to reduce holding costs, including exploring efficient warehousing.

### 4. How sufficient was the inventory in meeting order demands?
````sql
CREATE TABLE yearly_inventory_sufficiency_action AS
SELECT 
    i.year AS inventory_year,
    i.part_number,
    SUM(i.inv_oh) AS total_inventory_on_hand,
    SUM(i.to_make) AS total_to_make,
    i.inventory_status,
    CASE
        WHEN SUM(i.to_make) = 0 THEN 'No Additional Inventory Needed'
        WHEN SUM(i.to_make) > SUM(i.inv_oh) THEN 'Additional Inventory Needed'
        ELSE 'Sufficient Inventory Available'
    END AS sufficiency_status_action
FROM inventory i
GROUP BY i.part_number, i.year, i.inventory_status, i.last_sale_last_order
ORDER BY total_to_make DESC;
````
**Answer:**

![image](https://github.com/user-attachments/assets/979aba70-4710-40e2-ae94-630a11cc6c4a)

![image](https://github.com/user-attachments/assets/8c88955c-8271-41f1-a97f-798e569e1128)

20% of orders can be fulfilled immediately due to sufficient safety stock, while 80% remain unfulfilled due to insufficient inventory, highlighting the need for improved stock planning and replenishment. 

**Recommendation:**
- Maintaining adequate inventory should be balanced with managing holding costs for a swift replenishment process.
- Improve forecasting and stock planning to enable swift replenishment.

### 5. Which items in our inventory are not generating purchase demand?
````sql
CREATE TABLE no_demand AS
SELECT 
	part_number,
	material,
    	inv_oh AS inventory_on_hand,
    	inventory.last_sale_last_order,
    	inventory.last_sale_order_req_qty
FROM inventory
WHERE inventory_status = 'No Demand';
````
**Answer:**

![image](https://github.com/user-attachments/assets/fa12a498-4367-4376-94a1-b18fed4a39b1)

![image](https://github.com/user-attachments/assets/4a575138-db91-4118-979f-e7b9f7d9bae7)

Although Aluminum Alloy is a key revenue driver, many of the Top 10 No Demand parts, including AT-2127 and AT-2125, come from this class, resulting in holding costs.

**Recommendation:**
- Strategically liquidate no-demand inventory by targeting customers with obsolete aircraft needing these parts, thus creating new demand.
- Improve forecasting to minimize no-demand items and reduce holding costs.

### 6. Which materials should we prioritize?
````sql
CREATE TABLE abc_analysis AS
WITH InventoryValue AS (
    SELECT
        inventory.material AS material,
        ROUND(SUM(inventory.value_of_inv_onhand), 2) AS total_inventory_value
    FROM 
        inventory
    GROUP BY 
        inventory.material
),
CumulativeInventory AS (
    SELECT
        material,
        total_inventory_value,
        SUM(total_inventory_value) OVER (ORDER BY total_inventory_value DESC) AS cumulative_value,
        SUM(total_inventory_value) OVER () AS grand_total_value
    FROM 
        InventoryValue
)
SELECT
    material,
    total_inventory_value,
    ROUND((cumulative_value / grand_total_value) * 100, 2) AS cumulative_percentage,
    CASE 
        WHEN (cumulative_value / grand_total_value) * 100 <= 80 THEN 'A'
        WHEN (cumulative_value / grand_total_value) * 100 <= 95 THEN 'B'
        ELSE 'C'
    END AS abc_category
FROM 
    CumulativeInventory
ORDER BY 
    abc_category, total_inventory_value DESC;
````

**Answer:**

![image](https://github.com/user-attachments/assets/f120cbd0-ed9d-4d61-9232-ada2985a7920)
![image](https://github.com/user-attachments/assets/1d903a46-cf45-4e99-bf9a-cef33610501d)


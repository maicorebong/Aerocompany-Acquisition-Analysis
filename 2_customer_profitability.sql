-- Customer Profitability Analysis
CREATE TABLE customer_profitability AS
SELECT
    transactions_sales.customer AS customer_name,
    ROUND(SUM(transactions_sales.revenue), 2) AS total_revenue,
    ROUND(SUM(transactions_sales.profit_or_loss), 2) AS total_profit,
    ROUND(SUM(transactions_sales.profit_or_loss) * 100.0 / NULLIF(SUM(transactions_sales.revenue), 0), 2) AS profit_margin_percentage,
    ROUND(SUM(inventory.value_of_inv_onhand), 2) AS inventory_holding_cost,
    COUNT(DISTINCT inventory.part_number) AS distinct_products_sold
FROM transactions_sales
LEFT JOIN inventory
ON transactions_sales.customer = inventory.customer_name
GROUP BY transactions_sales.customer
ORDER BY profit_margin_percentage DESC;
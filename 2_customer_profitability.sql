-- Customer Profitability Analysis

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

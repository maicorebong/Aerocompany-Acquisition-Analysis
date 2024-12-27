-- Materials by Financials and Holding Cost Ratio

CREATE TABLE material_performance_holding AS
SELECT
    i.year AS inventory_year,
    i.material AS inventory_material,
    ROUND(SUM(t.revenue), 2) AS total_revenue,
    ROUND(SUM(t.profit_or_loss), 2) AS total_transaction_profit,
    ROUND(SUM(i.value_of_inv_onhand), 2) AS total_holding_cost,
    ROUND(SUM(i.value_of_inv_onhand) * 100.0 / NULLIF(SUM(t.revenue), 0), 2) AS holding_cost_to_revenue_ratio
FROM inventory i
LEFT JOIN transactions_sales t
ON i.material = t.material
GROUP BY i.year, i.material
ORDER BY i.year, holding_cost_to_revenue_ratio DESC;
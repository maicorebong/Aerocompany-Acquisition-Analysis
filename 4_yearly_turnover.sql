-- Yearly Inventory Turnover Analysis

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

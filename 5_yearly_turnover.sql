-- Yearly Inventory Turnover Analysis
CREATE TABLE yearly_turnover AS
SELECT
    inventory.year AS inventory_year,
    inventory.material AS inventory_material,
    SUM(inventory.inv_oh) AS total_inventory_on_hand,
    ROUND(SUM(inventory.value_of_inv_onhand), 2) AS total_holding_cost,
    ROUND(SUM(transactions_sales.revenue), 2) AS total_revenue,
    ROUND(SUM(transactions_sales.revenue) / NULLIF(SUM(inventory.value_of_inv_onhand), 0), 2) AS turnover_ratio,
    ROUND(SUM(transactions_sales.profit_or_loss), 2) AS total_transaction_profit
FROM inventory
LEFT JOIN transactions_sales
ON inventory.material = transactions_sales.material
AND inventory.year = transactions_sales.year
GROUP BY inventory.year, inventory.material
ORDER BY inventory.year, turnover_ratio DESC;
-- Materials by Financials and Holding Cost Ratio

CREATE TABLE material_performance_holding AS
SELECT
    inventory.year AS inventory_year,
    inventory.material AS inventory_material,
    ROUND(SUM(transactions_sales.revenue), 2) AS total_revenue,
    ROUND(SUM(transactions_sales.profit_or_loss), 2) AS total_transaction_profit,
    ROUND(SUM(inventory.value_of_inv_onhand), 2) AS total_holding_cost,
    ROUND(SUM(inventory.value_of_inv_onhand) * 100.0 / NULLIF(SUM(transactions_sales.revenue), 0), 2) AS holding_cost_to_revenue_ratio
FROM
    inventory
LEFT JOIN transactions_sales
    ON inventory.material = transactions_sales.material
GROUP BY inventory.year, inventory.material
ORDER BY inventory.year, holding_cost_to_revenue_ratio DESC;
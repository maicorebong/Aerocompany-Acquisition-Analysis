-- Yearly Inventory Sufficiency Analysis with existing inventory_status

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
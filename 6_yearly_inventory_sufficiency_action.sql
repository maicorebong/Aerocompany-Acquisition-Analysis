-- Yearly Inventory Sufficiency Analysis with existing inventory_status

CREATE TABLE yearly_inventory_sufficiency_action AS
SELECT 
    inventory.year AS inventory_year,
    inventory.part_number,
    SUM(inventory.inv_oh) AS total_inventory_on_hand,
    SUM(inventory.to_make) AS total_to_make,
    inventory.inventory_status,
    CASE
        WHEN SUM(inventory.to_make) = 0 THEN 'No Additional Inventory Needed'
        WHEN SUM(inventory.to_make) > SUM(inventory.inv_oh) THEN 'Additional Inventory Needed'
        ELSE 'Sufficient Inventory Available'
    END AS sufficiency_status_action
FROM inventory
GROUP BY inventory.part_number, inventory.year, inventory.inventory_status, inventory.last_sale_last_order
ORDER BY total_to_make DESC;
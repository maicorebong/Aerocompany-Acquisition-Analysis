-- ABC Analysis

CREATE TABLE abc_analysis AS
-- CTE 1: Calculate total inventory value per material
WITH InventoryValue AS (
    SELECT
        inventory.material AS material,
        ROUND(SUM(inventory.value_of_inv_onhand), 2) AS total_inventory_value
    FROM 
        inventory
    GROUP BY 
        inventory.material
),

-- CTE 2: Compute cumulative values and grand total
CumulativeInventory AS (
    SELECT
        material,
        total_inventory_value,
        SUM(total_inventory_value) OVER (ORDER BY total_inventory_value DESC) AS cumulative_value,
        SUM(total_inventory_value) OVER () AS grand_total_value
    FROM 
        InventoryValue
)

-- Final Query: Assign ABC categories based on cumulative percentage
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
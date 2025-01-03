CREATE TABLE no_demand AS
SELECT 
	part_number,
	material,
    inv_oh AS inventory_on_hand,
    inventory.last_sale_last_order,
    inventory.last_sale_order_req_qty,
    CASE
        WHEN inventory.inv_oh = 0 THEN 'No Stock'
        WHEN inventory.inv_oh > 0 THEN
            CASE 
                WHEN inventory.last_sale_last_order = 'Sale' THEN 'No Demand'
                WHEN inventory.last_sale_last_order = 'NO DEMAND' THEN 'No Demand'
                WHEN inventory.last_sale_last_order = 'Order' THEN
                    CASE
                        WHEN inventory.last_sale_order_req_qty - inventory.inv_oh >= 0 THEN 'Insufficient Stock'
                        ELSE 'Demand'
                    END
            END
    END AS inventory_status
FROM inventory
WHERE inventory_status = 'No Demand';
-- Analyze parts that how no purchase interest from the customers

CREATE TABLE no_demand AS
SELECT 
	part_number,
	material,
    	inv_oh AS inventory_on_hand,
    	inventory.last_sale_last_order,
    	inventory.last_sale_order_req_qty
FROM inventory
WHERE inventory_status = 'No Demand';

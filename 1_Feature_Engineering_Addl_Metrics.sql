USE abc_analysis;

/******TRANSACTIONS TABLE UPDATE******/

-- 1) Add new columns and metrics in transactions table
ALTER TABLE transactions_sales
ADD COLUMN cost DOUBLE,
ADD COLUMN revenue DOUBLE,
ADD COLUMN profit_or_loss DOUBLE;

-- 2) Populate 'cost' as 'Qty Sold/On Ord' * 'Std Unit Cost'
UPDATE transactions_sales
SET cost = qty_sold_order * std_cost;

-- 3) Populate 'revenue' as 'Qty Sold/On Ord' * 'Unit Price'
UPDATE transactions_sales
SET revenue = qty_sold_order * price;

-- 4) Populate 'profit_or_loss' as 'revenue' - 'cost'
UPDATE transactions_sales
SET profit_or_loss = revenue - cost;


/******INVENTORY TABLE UPDATE******/

-- 1) Add new columns
ALTER TABLE inventory
ADD COLUMN cost DOUBLE,
ADD COLUMN revenue DOUBLE,
ADD COLUMN profit_or_loss DOUBLE,
ADD COLUMN to_make INT,
ADD COLUMN value_of_inv_onhand DOUBLE,
ADD COLUMN inventory_status TEXT,
ADD COLUMN no_demand_value DOUBLE;

-- 2) Populate 'cost' as 'Last Sale or Last Order' * 'Std Unit Cost'
UPDATE inventory
SET cost = last_sale_order_req_qty * std_unit_cost;

-- 3) Populate 'revenue' as 'Last Sale or Last Order' * 'Unit Price'
UPDATE inventory
SET revenue = last_sale_order_req_qty * unit_price;

-- 4) Populate 'profit_or_loss' as 'revenue' - 'cost'
UPDATE inventory
SET profit_or_loss = revenue - cost;

-- 5) Populate 'to_make' based on 'Last Sale or Last Order' status and corresponding 'Last Sale or Req Qty' vs 'Inventory Onhand'
UPDATE inventory
SET to_make =
	CASE WHEN last_sale_last_order = 'Order' THEN 
        CASE WHEN last_sale_order_req_qty = 0 THEN 0
            WHEN last_sale_order_req_qty - inv_oh > 0 THEN last_sale_order_req_qty - inv_oh
            ELSE inv_oh - last_sale_order_req_qty
        END
    ELSE 0
	END;

-- 6) Populate 'value_of_inv_onhand' as 'std_unit_cost * inv_oh'
UPDATE inventory
SET value_of_inv_onhand = std_unit_cost * inv_oh;

-- 7) Populate 'inventory_status' based on inventory and order activity:
-- 'No Stock', 'No Demand', 'Insufficient Stock', or 'Demand'.
UPDATE inventory
SET inventory_status =
	CASE WHEN inv_oh = 0 THEN 'No Stock'
		WHEN inv_oh > 0 THEN 
			CASE WHEN last_sale_last_order = 'Sale' THEN 'No Demand'
				WHEN last_sale_last_order = 'NO DEMAND' THEN 'No Demand'
				WHEN last_sale_last_order = 'Order' THEN 
					CASE
						WHEN last_sale_order_req_qty - inv_oh >= 0 THEN 'Insufficient Stock'
						ELSE 'Demand'
					END
			END
	END;

-- 8) Populate 'no_demand_value' as 'std_unit_cost * inv_oh' if 'inventory_status' is 'No Demand'
UPDATE inventory
SET no_demand_value =
	CASE WHEN inventory_status = 'No Demand' THEN std_unit_cost * inv_oh
    ELSE 0
END;

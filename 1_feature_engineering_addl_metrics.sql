USE abc_analysis;

/******TRANSACTIONS TABLE UPDATE******/

-- 1) Add new columns as blank in transactions table
ALTER TABLE transactions_sales
ADD COLUMN cost DOUBLE,
ADD COLUMN revenue DOUBLE,
ADD COLUMN profit_or_loss DOUBLE;

-- 2) Populate value of new metrics
UPDATE transactions_sales
SET
	cost = qty_sold_order * std_cost -- Populate'cost' as 'Qty Sold/On Ord' * 'Std Unit Cost'
	revenue = qty_sold_order * price -- Populate 'revenue' as 'Qty Sold/On Ord' * 'Unit Price'
	profit_or_loss = revenue - cost; -- Populate 'profit_or_loss' as 'revenue' - 'cost';


/******INVENTORY TABLE UPDATE******/

-- 1) Add new blank columns
ALTER TABLE inventory
ADD COLUMN cost DOUBLE,
ADD COLUMN revenue DOUBLE,
ADD COLUMN profit_or_loss DOUBLE,
ADD COLUMN to_make INT,
ADD COLUMN value_of_inv_onhand DOUBLE,
ADD COLUMN inventory_status TEXT,
ADD COLUMN no_demand_value DOUBLE;

-- 2) Populate new metrics
UPDATE inventory
SET
	cost = last_sale_order_req_qty * std_unit_cost,
	revenue = last_sale_order_req_qty * unit_price,
	profit_or_loss = revenue - cost,
	value_of_inv_onhand = std_unit_cost * inv_oh;

-- 3) Populate 'to_make' based on 'Last Sale or Last Order' status and corresponding 'Last Sale or Req Qty' vs 'Inventory Onhand'
UPDATE inventory
SET to_make =
	CASE WHEN last_sale_last_order = 'Order' THEN 
        	CASE WHEN last_sale_order_req_qty = 0 THEN 0
            	WHEN last_sale_order_req_qty - inv_oh > 0 THEN last_sale_order_req_qty - inv_oh
            	ELSE inv_oh - last_sale_order_req_qty
        	END
    	ELSE 0
	END;

-- 4) Populate 'inventory_status' based on inventory and order activity:
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

-- 5) Populate 'no_demand_value' as 'std_unit_cost * inv_oh' if 'inventory_status' is 'No Demand'
UPDATE inventory
SET no_demand_value =
	CASE WHEN inventory_status = 'No Demand' THEN std_unit_cost * inv_oh
    	ELSE 0
	END;

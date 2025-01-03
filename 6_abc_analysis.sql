-- ABC Analysis

CREATE TABLE abc_analysis AS
-- CTE 1: Calculate total revenue per material
WITH MaterialRevenue AS (
    SELECT
        material,
        ROUND(SUM(revenue), 2) AS total_revenue
    FROM 
        transactions_sales
    GROUP BY 
        material
),

-- CTE 2: Compute cumulative revenue and grand total
CumulativeRevenue AS (
    SELECT
        material,
        total_revenue,
        SUM(total_revenue) OVER (ORDER BY total_revenue DESC) AS cumulative_revenue,
        SUM(total_revenue) OVER () AS grand_total_revenue
    FROM 
        MaterialRevenue
)

-- Final Query: Assign ABC categories based on cumulative percentage
SELECT
    material,
    total_revenue,
    ROUND((cumulative_revenue / grand_total_revenue) * 100, 2) AS cumulative_percentage,
    CASE 
        WHEN (cumulative_revenue / grand_total_revenue) * 100 <= 80 THEN 'A'
        WHEN (cumulative_revenue / grand_total_revenue) * 100 <= 95 THEN 'B'
        ELSE 'C'
    END AS abc_category
FROM 
    CumulativeRevenue
ORDER BY 
    abc_category, total_revenue DESC;

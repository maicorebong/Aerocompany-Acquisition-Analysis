-- Contribution of Material to Total Revenue

-- calculate total annual revenue for each year
WITH yearly_totals AS (
    SELECT 
        year AS transaction_year,
        SUM(revenue) AS total_annual_revenue
    FROM transactions_sales
    GROUP BY year
)

-- calculate revenue contribution of each material
SELECT
    t.year AS transaction_year,
    t.material,
    ROUND(SUM(t.revenue), 2) AS total_revenue,
    ROUND((SUM(t.revenue) / y.total_annual_revenue) * 100, 2) AS revenue_percentage
FROM transactions_sales t
JOIN yearly_totals y
ON t.year = y.transaction_year
GROUP BY t.year, t.material, y.total_annual_revenue
ORDER BY year, total_revenue DESC;

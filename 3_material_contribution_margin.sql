-- Contribution of Material to Total Revenue

CREATE TABLE material_contribution_margin AS
SELECT
    year AS transaction_year,
    material,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(revenue) * 100.0 / 
          (SELECT SUM(revenue) FROM transactions_sales WHERE year = t.year), 2) AS revenue_percentage
FROM transactions_sales t
GROUP BY year, material
ORDER BY transaction_year, total_revenue DESC;
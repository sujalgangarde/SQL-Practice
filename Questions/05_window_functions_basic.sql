USE CompanyAnalytics;

[cite_start]-- Q1: Rank employees by salary within each department. [cite: 129, 130]
SELECT
    employee_id,
    department_id,
    salary,
    RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
FROM Employees;

[cite_start]-- Q2: Find the moving average of sales over the last 3 days. [cite: 142, 143, 144, 145, 146]
-- This query assumes a single order per day for simplicity.
SELECT
    order_date,
    SUM(total_amount) AS daily_revenue,
    AVG(SUM(total_amount)) OVER (ORDER BY order_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3day
FROM Orders
GROUP BY order_date
ORDER BY order_date;

[cite_start]-- Q3: Calculate cumulative revenue by day. [cite: 188, 189, 190, 191]
SELECT
    order_date,
    SUM(total_amount) AS daily_revenue,
    SUM(SUM(total_amount)) OVER (ORDER BY order_date) AS cumulative_revenue
FROM Orders
GROUP BY order_date
ORDER BY order_date;

[cite_start]-- Q4: Show the last purchase for each customer along with the order amount. [cite: 266, 267, 268, 269, 270]
WITH ranked_orders AS (
    SELECT
        customer_id,
        order_id,
        total_amount,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rn
    FROM Orders
)
SELECT
    customer_id,
    order_id,
    total_amount
FROM ranked_orders
WHERE rn = 1;

[cite_start]-- Q5: Calculate year-over-year growth in revenue. [cite: 274, 275, 276, 277]
WITH yearly_revenue AS (
    SELECT
        EXTRACT(YEAR FROM order_date) AS year,
        SUM(total_amount) AS revenue
    FROM Orders
    GROUP BY EXTRACT(YEAR FROM order_date)
)
SELECT
    year,
    revenue,
    LAG(revenue, 1, 0) OVER (ORDER BY year) AS previous_year_revenue,
    revenue - LAG(revenue, 1, 0) OVER (ORDER BY year) AS yoy_growth
FROM yearly_revenue
ORDER BY year;
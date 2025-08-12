USE CompanyAnalytics;

[cite_start]-- Q1: Find continuous login streaks (e.g., users who logged in 3 or more consecutive days). [cite: 291, 292, 293, 294, 295, 296, 297, 298, 299, 300]
WITH date_groups AS (
    SELECT
        user_id,
        login_date,
        login_date - (ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY login_date) * INTERVAL '1 day') AS grp
    FROM Logins
)
SELECT
    user_id,
    MIN(login_date) AS streak_start,
    MAX(login_date) AS streak_end,
    COUNT(*) AS streak_length
FROM date_groups
GROUP BY user_id, grp
HAVING COUNT(*) >= 3;

[cite_start]-- Q2: Find products that are always sold together (Market basket analysis). [cite: 321, 322, 323, 324, 325, 326, 327, 328]
-- This finds pairs of products frequently bought together.
SELECT
    A.product_id AS product_A,
    B.product_id AS product_B,
    COUNT(*) AS times_bought_together
FROM Order_Details A
JOIN Order_Details B ON A.order_id = B.order_id AND A.product_id < B.product_id
GROUP BY A.product_id, B.product_id
ORDER BY times_bought_together DESC;

[cite_start]-- Q3: Calculate the time between user signup and their first purchase. [cite: 413, 414, 415, 416, 417, 418, 419, 420]
WITH first_purchase AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_purchase_date
    FROM Orders
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    fp.first_purchase_date - c.signup_date AS days_to_first_purchase
FROM Customers c
JOIN first_purchase fp ON c.customer_id = fp.customer_id;

[cite_start]-- Q4: Find the percentage of total sales contributed by the top 10% of customers. [cite: 385, 386, 387, 388, 389, 390, 391, 392]
WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(total_amount) AS revenue
    FROM Orders
    GROUP BY customer_id
),
ranked_customers AS (
    SELECT
        revenue,
        NTILE(10) OVER (ORDER BY revenue DESC) AS decile
    FROM customer_revenue
)
SELECT
    SUM(CASE WHEN decile = 1 THEN revenue ELSE 0 END) * 100.0 / SUM(revenue) AS pct_from_top_10_percent
FROM ranked_customers;

[cite_start]-- Q5: Calculate customer retention by month (Cohort analysis). [cite: 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317]
WITH cohorts AS (
    SELECT
        customer_id,
        TRUNC(MIN(order_date), 'MONTH') AS cohort_month
    FROM Orders
    GROUP BY customer_id
),
monthly_activity AS (
    SELECT DISTINCT
        customer_id,
        TRUNC(order_date, 'MONTH') AS order_month
    FROM Orders
)
SELECT
    c.cohort_month,
    EXTRACT(YEAR FROM m.order_month) AS activity_year,
    EXTRACT(MONTH FROM m.order_month) AS activity_month,
    COUNT(DISTINCT c.customer_id) AS active_customers
FROM cohorts c
JOIN monthly_activity m ON c.customer_id = m.customer_id
WHERE m.order_month >= c.cohort_month
GROUP BY c.cohort_month, activity_year, activity_month
ORDER BY c.cohort_month, activity_year, activity_month;
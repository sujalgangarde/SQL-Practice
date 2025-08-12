USE CompanyAnalytics;

[cite_start]-- Q1: Retrieve customers who made purchases on consecutive days. [cite: 170, 171, 172, 173, 174, 175, 176]
WITH date_diff_cte AS (
    SELECT
        customer_id,
        order_date,
        LAG(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order_date
    FROM Orders
)
SELECT
    customer_id,
    order_date,
    prev_order_date
FROM date_diff_cte
WHERE order_date - prev_order_date = 1;

[cite_start]-- Q2: Calculate the average time between purchases for each customer. [cite: 253, 254, 255, 256, 257, 258, 259, 260, 261, 262]
WITH purchase_gaps AS (
    SELECT
        customer_id,
        order_date,
        order_date - LAG(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS gap_days
    FROM Orders
)
SELECT
    customer_id,
    AVG(gap_days) AS avg_gap_between_purchases
FROM purchase_gaps
WHERE gap_days IS NOT NULL
GROUP BY customer_id;

[cite_start]-- Q3: Retrieve customers with increasing order amounts over their last 3 orders. [cite: 361, 362, 363, 364, 365, 366, 367, 368, 369]
WITH lagged_amounts AS (
    SELECT
        customer_id,
        order_date,
        total_amount,
        LAG(total_amount, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_amount_1,
        LAG(total_amount, 2) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_amount_2
    FROM Orders
)
SELECT
    customer_id,
    order_date,
    total_amount
FROM lagged_amounts
WHERE total_amount > prev_amount_1 AND prev_amount_1 > prev_amount_2;

[cite_start]-- Q4: Find employees with a salary higher than their department's average. [cite: 402, 403, 404, 405, 406, 407, 408, 409]
WITH dept_avg AS (
    SELECT
        department_id,
        AVG(salary) AS avg_salary
    FROM Employees
    GROUP BY department_id
)
SELECT
    e.employee_id,
    e.first_name,
    e.salary,
    d.avg_salary AS department_avg_salary
FROM Employees e
JOIN dept_avg d ON e.department_id = d.department_id
WHERE e.salary > d.avg_salary;

[cite_start]-- Q5: Find the longest gap between orders for each customer. [cite: 424, 425, 426, 427, 428, 429]
WITH purchase_gaps AS (
    SELECT
        customer_id,
        order_date - LAG(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS gap_days
    FROM Orders
)
SELECT
    customer_id,
    MAX(gap_days) AS max_gap
FROM purchase_gaps
WHERE gap_days IS NOT NULL
GROUP BY customer_id;
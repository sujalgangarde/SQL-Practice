USE CompanyAnalytics;

[cite_start]-- Q1: Retrieve all employees who joined in 2023. [cite: 52, 53, 54]
-- Note: EXTRACT is the ANSI SQL standard function.
SELECT
    employee_id,
    first_name,
    hire_date
FROM Employees
WHERE EXTRACT(YEAR FROM hire_date) = 2023;

[cite_start]-- Q2: Find all employees hired on weekends. [cite: 109, 110, 111]
-- Note: EXTRACT(DOW) returns 0 for Sunday and 6 for Saturday in PostgreSQL.
-- This can vary between SQL dialects. A CASE statement is more portable.
SELECT
    employee_id,
    first_name,
    hire_date
FROM Employees
WHERE EXTRACT(ISODOW FROM hire_date) IN (6, 7); -- ISO standard: 6=Saturday, 7=Sunday

[cite_start]-- Q3: Get monthly sales revenue and order count. [cite: 121, 122, 123, 124, 125]
-- Note: ANSI SQL uses string/date functions that can vary. TRUNC or formatting is common.
SELECT
    TO_CHAR(order_date, 'YYYY-MM') AS month,
    SUM(total_amount) AS total_revenue,
    COUNT(order_id) AS order_count
FROM Orders
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month;

[cite_start]-- Q4: Find customers who placed orders every month in 2023. [cite: 134, 135, 136, 137, 138]
SELECT customer_id
FROM Orders
WHERE EXTRACT(YEAR FROM order_date) = 2023
GROUP BY customer_id
HAVING COUNT(DISTINCT EXTRACT(MONTH FROM order_date)) = 12;

[cite_start]-- Q5: Find churned customers (no orders in the last 6 months). [cite: 180, 181, 182, 183, 184]
-- Note: Date arithmetic syntax varies. This uses interval syntax.
SELECT customer_id
FROM Orders
GROUP BY customer_id
HAVING MAX(order_date) < (CURRENT_DATE - INTERVAL '6' MONTH);
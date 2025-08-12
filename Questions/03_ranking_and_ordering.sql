USE CompanyAnalytics;

[cite_start]-- Q1: Get the top 3 highest-paid employees. [cite: 31, 32, 33]
-- Note: ANSI SQL uses FETCH FIRST, while dialects use TOP or LIMIT.
SELECT
    employee_id,
    first_name,
    salary
FROM Employees
ORDER BY salary DESC
FETCH FIRST 3 ROWS ONLY;

[cite_start]-- Q2: Identify the most selling product. [cite: 79, 80, 81, 82]
SELECT
    p.product_id,
    p.product_name,
    SUM(od.quantity) AS total_qty
FROM Order_Details od
JOIN Products p ON od.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_qty DESC
FETCH FIRST 1 ROW ONLY;

[cite_start]-- Q3: Get the latest order placed by each customer. [cite: 65, 66, 67, 68]
SELECT
    customer_id,
    MAX(order_date) AS latest_order_date
FROM Orders
GROUP BY customer_id;

[cite_start]-- Q4: Identify top-performing departments by average salary. [cite: 195, 196, 197]
SELECT
    d.department_name,
    AVG(e.salary) AS avg_salary
FROM Employees e
JOIN Departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY avg_salary DESC;

[cite_start]-- Q5: Identify the first and last order date for each customer. [cite: 150, 151, 152, 153, 154]
SELECT
    customer_id,
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order
FROM Orders
GROUP BY customer_id;
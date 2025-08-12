USE CompanyAnalytics;

[cite_start]-- Q1: Find duplicate records in a table (e.g., employees with the same salary). [cite: 5, 6, 7]
SELECT
    salary,
    COUNT(*) AS duplicate_count
FROM Employees
GROUP BY salary
HAVING COUNT(*) > 1;

[cite_start]-- Q2: Calculate the total revenue per product. [cite: 24, 25, 26, 27]
SELECT
    p.product_id,
    p.product_name,
    SUM(od.quantity * p.price) AS total_revenue
FROM Order_Details od
JOIN Products p ON od.product_id = p.product_id
GROUP BY p.product_id, p.product_name;

[cite_start]-- Q3: Show the count of orders per customer. [cite: 46, 47, 48]
SELECT
    customer_id,
    COUNT(order_id) AS order_count
FROM Orders
GROUP BY customer_id;

[cite_start]-- Q4: Calculate the average order value per customer. [cite: 58, 59, 60, 61]
SELECT
    customer_id,
    AVG(total_amount) AS avg_order_value
FROM Orders
GROUP BY customer_id;

[cite_start]-- Q5: List employees whose salary is within a range. [cite: 115, 116, 117]
SELECT
    employee_id,
    first_name,
    last_name,
    salary
FROM Employees
WHERE salary BETWEEN 80000 AND 100000;
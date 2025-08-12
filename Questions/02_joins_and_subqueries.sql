USE CompanyAnalytics;

[cite_start]-- Q1: Find employees without a department. [cite: 16, 17, 18, 19, 20]
SELECT
    e.employee_id,
    e.first_name,
    e.last_name
FROM Employees e
LEFT JOIN Departments d ON e.department_id = d.department_id
WHERE d.department_id IS NULL;

[cite_start]-- Q2: Retrieve the second highest salary from the Employee table. [cite: 11, 12]
SELECT MAX(salary) AS SecondHighestSalary
FROM Employees
WHERE salary < (SELECT MAX(salary) FROM Employees);

[cite_start]-- Q3: Find customers who made purchases but never returned products. [cite: 37, 38, 39, 40, 41, 42]
SELECT DISTINCT
    c.customer_id
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE c.customer_id NOT IN (SELECT o.customer_id FROM Orders o JOIN Returns r ON o.order_id = r.order_id);

[cite_start]-- Q4: Find products never sold. [cite: 72, 73, 74, 75]
SELECT
    p.product_id,
    p.product_name
FROM Products p
LEFT JOIN Order_Details od ON p.product_id = od.product_id
WHERE od.order_detail_id IS NULL;

[cite_start]-- Q5: Retrieve customers with orders above the average order value. [cite: 102, 103, 104, 105]
SELECT
    customer_id,
    order_id,
    total_amount
FROM Orders
WHERE total_amount > (SELECT AVG(total_amount) FROM Orders);
USE CompanyAnalytics;

[cite_start]-- Q1: Count how many customers placed more than 5 orders. [cite: 94, 95, 96, 97, 98]
SELECT COUNT(*) AS customer_count
FROM (
    SELECT customer_id
    FROM Orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 5
) AS frequent_customers;

[cite_start]-- Q2: Calculate revenue generated from new customers (first-time orders). [cite: 210, 211, 212, 213, 214, 215, 216, 217]
WITH first_orders AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_order_date
    FROM Orders
    GROUP BY customer_id
)
SELECT
    SUM(o.total_amount) AS new_customer_revenue
FROM Orders o
JOIN first_orders f ON o.customer_id = f.customer_id AND o.order_date = f.first_order_date;

[cite_start]-- Q3: Find the percentage of employees in each department. [cite: 221, 222, 223, 224, 225, 226, 227]
SELECT
    d.department_name,
    COUNT(e.employee_id) * 100.0 / (SELECT COUNT(*) FROM Employees) AS percentage_of_total
FROM Departments d
JOIN Employees e ON d.department_id = e.department_id
GROUP BY d.department_name;

[cite_start]-- Q4: Show product sales distribution (percent of total revenue). [cite: 158, 159, 160, 161, 162, 163, 164, 165, 166]
WITH ProductRevenue AS (
    SELECT
        p.product_name,
        SUM(od.quantity * p.price) AS revenue
    FROM Order_Details od
    JOIN Products p ON od.product_id = p.product_id
    GROUP BY p.product_name
)
SELECT
    product_name,
    revenue,
    revenue * 100.0 / (SELECT SUM(revenue) FROM ProductRevenue) AS percentage_of_total_revenue
FROM ProductRevenue;

[cite_start]-- Q5: Find customers who ordered more than the average number of orders per customer. [cite: 202, 203, 204, 205, 206]
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(order_id) AS order_count
    FROM Orders
    GROUP BY customer_id
)
SELECT customer_id, order_count
FROM customer_orders
WHERE order_count > (SELECT AVG(order_count) FROM customer_orders);
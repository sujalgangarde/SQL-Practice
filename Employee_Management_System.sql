-- ====================================================================
-- Project: Employee Management System (All-in-One Script)
-- Description: This single file creates the database, tables,
--              inserts data, and runs a variety of queries covering
--              CRUD, joins, aggregation, and other core SQL operations.
-- ====================================================================

-- ----------------------------------
-- PART 1: DATABASE AND TABLE CREATION
-- ----------------------------------

-- Drop the database if it already exists to ensure a clean setup
DROP DATABASE IF EXISTS EmployeeDB;

-- Create the new database
CREATE DATABASE EmployeeDB;

-- Select the database to use for all subsequent commands
USE EmployeeDB;

-- ## Table Creation ##

-- Create the Departments table
CREATE TABLE Departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

-- Create the Jobs table
CREATE TABLE Jobs (
    job_id INT PRIMARY KEY AUTO_INCREMENT,
    job_title VARCHAR(100) NOT NULL UNIQUE,
    min_salary DECIMAL(10, 2),
    max_salary DECIMAL(10, 2)
);

-- Create the Employees table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    hire_date DATE NOT NULL,
    job_id INT,
    department_id INT,
    salary DECIMAL(10, 2),
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (job_id) REFERENCES Jobs(job_id),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- ----------------------------------
-- PART 2: DATA INSERTION
-- ----------------------------------

-- Insert data into Departments
INSERT INTO Departments (department_name) VALUES
('Engineering'),
('Human Resources'),
('Sales'),
('Marketing');

-- Insert data into Jobs
INSERT INTO Jobs (job_title, min_salary, max_salary) VALUES
('Software Engineer', 70000, 120000),
('Senior Engineer', 95000, 150000),
('HR Specialist', 60000, 90000),
('Sales Manager', 80000, 140000),
('Marketing Analyst', 65000, 100000);

-- Insert data into Employees
INSERT INTO Employees (first_name, last_name, email, hire_date, job_id, department_id, salary) VALUES
('Alice', 'Johnson', 'alice.j@example.com', '2022-01-15', 2, 1, 130000.00),
('Bob', 'Smith', 'bob.s@example.com', '2023-03-20', 1, 1, 85000.00),
('Charlie', 'Brown', 'charlie.b@example.com', '2021-07-30', 4, 3, 110000.00),
('Diana', 'Miller', 'diana.m@example.com', '2023-08-01', 3, 2, 75000.00),
('Eve', 'Davis', 'eve.d@example.com', '2020-05-18', 5, 4, 88000.00),
('Frank', 'White', 'frank.w@example.com', '2022-11-05', 1, 1, 92000.00);


-- ----------------------------------
-- PART 3: CORE QUERIES & OPERATIONS
-- ----------------------------------

-- ## Basic Data Retrieval (SELECT) ##

-- Query 1: Retrieve all information for all active employees.
SELECT * FROM Employees WHERE is_active = TRUE;

-- Query 2: Retrieve the full name, job title, and department for all employees.
SELECT
    e.first_name,
    e.last_name,
    j.job_title,
    d.department_name
FROM Employees e
JOIN Jobs j ON e.job_id = j.job_id
JOIN Departments d ON e.department_id = d.department_id;

-- ## Filtering Data (WHERE) ##

-- Query 3: Find all employees in the 'Engineering' department.
SELECT e.first_name, e.last_name
FROM Employees e
JOIN Departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Engineering';

-- Query 4: Find all employees hired in the year 2023.
-- Note: EXTRACT is the standard ANSI SQL function for this.
SELECT first_name, last_name, hire_date
FROM Employees
WHERE EXTRACT(YEAR FROM hire_date) = 2023;

-- ## Aggregation and Grouping (GROUP BY & HAVING) ##

-- Query 5: Count the number of employees in each department.
SELECT
    d.department_name,
    COUNT(e.employee_id) AS employee_count
FROM Employees e
JOIN Departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY employee_count DESC;

-- Query 6: Calculate the average salary for each job title.
SELECT
    j.job_title,
    AVG(e.salary) AS average_salary
FROM Employees e
JOIN Jobs j ON e.job_id = j.job_id
GROUP BY j.job_title;

-- Query 7: Find departments that have more than 1 employee.
SELECT
    d.department_name,
    COUNT(e.employee_id) AS employee_count
FROM Employees e
JOIN Departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING COUNT(e.employee_id) > 1;

-- ## Subqueries ##

-- Query 8: Find employees who earn more than the company's average salary.
SELECT
    first_name,
    last_name,
    salary
FROM Employees
WHERE salary > (SELECT AVG(salary) FROM Employees);

-- ## Data Modification (UPDATE, DELETE) ##

-- Query 9: Give a 5% salary increase to all employees in the 'Engineering' department.
UPDATE Employees
SET salary = salary * 1.05
WHERE department_id = (SELECT department_id FROM Departments WHERE department_name = 'Engineering');

-- Query 10: Logically "delete" an employee by setting their status to inactive.
UPDATE Employees
SET is_active = FALSE
WHERE employee_id = 5;

-- ## Advanced Queries (VIEW, WINDOW FUNCTION) ##

-- Query 11: Create a View for a simplified employee summary.
-- A view acts like a virtual table and can simplify complex queries.
CREATE VIEW vw_employee_summary AS
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    j.job_title,
    d.department_name,
    e.salary
FROM Employees e
JOIN Jobs j ON e.job_id = j.job_id
JOIN Departments d ON e.department_id = d.department_id
WHERE e.is_active = TRUE;

-- Now you can query the view just like a table:
SELECT * FROM vw_employee_summary WHERE department_name = 'Sales';

-- Query 12: Rank employees within each department based on their salary.
SELECT
    first_name,
    last_name,
    salary,
    d.department_name,
    RANK() OVER (PARTITION BY d.department_name ORDER BY salary DESC) AS salary_rank_in_dept
FROM Employees e
JOIN Departments d ON e.department_id = d.department_id;
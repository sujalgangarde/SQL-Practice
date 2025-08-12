-- ====================================================================
-- File: 00_setup_database.sql
-- Description: Creates the database, tables, and inserts sample data
--              for all subsequent query files. Run this file first.
-- ====================================================================

-- Drop the database if it exists to start fresh
DROP DATABASE IF EXISTS CompanyAnalytics;

-- Create and select the database
CREATE DATABASE CompanyAnalytics;
USE CompanyAnalytics;

-- Create tables
CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    salary DECIMAL(10, 2),
    hire_date DATE,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    signup_date DATE
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Returns (
    return_id INT PRIMARY KEY,
    order_id INT,
    return_date DATE,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Logins (
    log_id INT PRIMARY KEY,
    user_id INT,
    login_date DATE
);

-- Insert sample data
INSERT INTO Departments (department_id, department_name) VALUES
(1, 'Engineering'),
(2, 'Sales'),
(3, 'HR');

INSERT INTO Employees (employee_id, first_name, last_name, salary, hire_date, department_id) VALUES
(101, 'Alice', 'Smith', 90000, '2022-03-15', 1),
(102, 'Bob', 'Johnson', 110000, '2021-07-20', 1),
(103, 'Charlie', 'Brown', 80000, '2023-01-10', 2),
(104, 'Diana', 'Prince', 85000, '2023-05-25', 2),
(105, 'Eve', 'Adams', 120000, '2020-11-01', 1),
(106, 'Frank', 'White', 75000, '2023-08-11', null);

INSERT INTO Customers (customer_id, signup_date) VALUES
(1, '2022-01-10'),
(2, '2022-02-15'),
(3, '2023-03-20');

INSERT INTO Products (product_id, product_name, price) VALUES
(1, 'Laptop', 1200.00),
(2, 'Mouse', 25.00),
(3, 'Keyboard', 75.00);

INSERT INTO Orders (order_id, customer_id, order_date, total_amount) VALUES
(1001, 1, '2023-01-15', 1225.00),
(1002, 2, '2023-01-16', 75.00),
(1003, 1, '2023-01-17', 25.00),
(1004, 3, '2023-04-01', 1200.00),
(1005, 1, '2023-04-05', 75.00);

INSERT INTO Order_Details (order_detail_id, order_id, product_id, quantity) VALUES
(1, 1001, 1, 1),
(2, 1001, 2, 1),
(3, 1002, 3, 1),
(4, 1003, 2, 1),
(5, 1004, 1, 1),
(6, 1005, 3, 1);

INSERT INTO Returns (return_id, order_id, return_date) VALUES
(1, 1002, '2023-01-20');

INSERT INTO Logins (log_id, user_id, login_date) VALUES
(1, 1, '2024-01-01'),
(2, 1, '2024-01-02'),
(3, 2, '2024-01-05'),
(4, 1, '2024-01-03'),
(5, 2, '2024-01-07');
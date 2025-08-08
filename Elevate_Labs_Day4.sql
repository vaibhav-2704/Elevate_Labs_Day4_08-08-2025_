# Create Database: northwind_internship
CREATE DATABASE northwind_internship;

# Use Database: northwind_internship
USE northwind_internship;
-------------------------------------------------------------------------------------------------------------
# Create Table: categories
CREATE TABLE categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(255),
    Description TEXT
);
-------------------------------------------------------------------------------------------------------------
# Select Top 5 Records from categories
SELECT * FROM categories LIMIT 5;
-------------------------------------------------------------------------------------------------------------
# Create Table: customers
CREATE TABLE customers (
    CustomerID VARCHAR(10) PRIMARY KEY,
    CompanyName VARCHAR(255),
    ContactName VARCHAR(255),
    ContactTitle VARCHAR(255),
    City VARCHAR(100),
    Country VARCHAR(100)
);
------------------------------------------------------------------------------------------------------------
# Select Top 5 Records from customers
SELECT * FROM customers LIMIT 5;
------------------------------------------------------------------------------------------------------------
# Create Table: orders
CREATE TABLE orders (
    OrderID INT PRIMARY KEY,
    CustomerID VARCHAR(10),
    EmployeeID INT,
    OrderDate DATE,
    RequiredDate DATE,
    ShippedDate DATE,
    ShipperID INT,
    Freight DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID)
);
-----------------------------------------------------------------------------------------------------------
# Select Top 5 Records from orders
SELECT * FROM orders LIMIT 5;
-----------------------------------------------------------------------------------------------------------
# Create Table: employees (initial attempt)
CREATE TABLE employees (
    employeeID INT PRIMARY KEY,
    employeeName VARCHAR(255),
    title VARCHAR(255),
    city VARCHAR(100),
    country VARCHAR(100),
    reportsTo INT
);
----------------------------------------------------------------------------------------------------------
# Create Table: employees (final with NULL support)
CREATE TABLE employees (
    employeeID INT PRIMARY KEY,
    employeeName VARCHAR(255),
    title VARCHAR(255),
    city VARCHAR(100),
    country VARCHAR(100),
    reportsTo INT NULL
);
---------------------------------------------------------------------------------------------------------
# Select Top 5 Records from employees
SELECT * FROM employees LIMIT 5;
---------------------------------------------------------------------------------------------------------
# Create Table: products
CREATE TABLE products (
    productID INT PRIMARY KEY,
    productName VARCHAR(255),
    quantityPerUnit VARCHAR(100),
    unitPrice DECIMAL(10, 2),
    discontinued BOOLEAN,
    categoryID INT,
    FOREIGN KEY (categoryID) REFERENCES categories(categoryID)
);
----------------------------------------------------------------------------------------------------------
# Select Top 5 Records from products
SELECT * FROM products LIMIT 5;
----------------------------------------------------------------------------------------------------------
# Create Table: shippers
CREATE TABLE shippers (
    shipperID INT PRIMARY KEY,
    companyName VARCHAR(255)
);
----------------------------------------------------------------------------------------------------------
# Select Top 5 Records from shippers
SELECT * FROM shippers LIMIT 5;
----------------------------------------------------------------------------------------------------------
# Create Table: orderDetails
CREATE TABLE orderDetails (
    orderID INT,
    productID INT,
    unitPrice DECIMAL(10, 2),
    quantity INT,
    discount DECIMAL(4, 2),
    PRIMARY KEY (orderID, productID),
    FOREIGN KEY (orderID) REFERENCES orders(orderID),
    FOREIGN KEY (productID) REFERENCES products(productID)
);
----------------------------------------------------------------------------------------------------------
# Select Top 5 Records from orderDetails
SELECT * FROM orderDetails LIMIT 5;
----------------------------------------------------------------------------------------------------------
# Filter Customers from Germany
SELECT *
FROM customers
WHERE country = 'Germany';
----------------------------------------------------------------------------------------------------------
# List Employees with Their Managers
SELECT 
    e.employeeID,
    e.employeeName AS Employee,
    m.employeeName AS Manager
FROM employees e
LEFT JOIN employees m ON e.reportsTo = m.employeeID;
----------------------------------------------------------------------------------------------------------
# Count of Customers Grouped by Country
SELECT 
    country,
    COUNT(customerID) AS total_customers
FROM customers
GROUP BY country
ORDER BY total_customers DESC;
----------------------------------------------------------------------------------------------------------
# Top 5 Most Expensive Products
SELECT 
    productName,
    unitPrice,
    quantityPerUnit
FROM products
ORDER BY unitPrice DESC
LIMIT 5;
----------------------------------------------------------------------------------------------------------
# Customer Count per Country (Repeated Query)
SELECT 
    country,
    COUNT(*) AS customer_count
FROM customers
GROUP BY country
ORDER BY customer_count DESC;
----------------------------------------------------------------------------------------------------------
# Discontinued Products with Their Categories
SELECT 
    p.productName,
    c.categoryName,
    p.unitPrice
FROM products p
JOIN categories c ON p.categoryID = c.categoryID
WHERE p.discontinued = 1;
----------------------------------------------------------------------------------------------------------
# Top 5 Customers by Number of Orders
SELECT 
    c.customerID,
    c.companyName,
    COUNT(o.orderID) AS totalOrders
FROM customers c
JOIN orders o ON c.customerID = o.customerID
GROUP BY c.customerID, c.companyName
ORDER BY totalOrders DESC
LIMIT 5;
----------------------------------------------------------------------------------------------------------
# Average Unit Price per Category
SELECT 
    c.categoryID,
    c.categoryName,
    ROUND(AVG(p.unitPrice), 2) AS avgUnitPrice
FROM categories c
JOIN products p ON c.categoryID = p.categoryID
GROUP BY c.categoryID, c.categoryName;
----------------------------------------------------------------------------------------------------------
# Order Count by Country
SELECT 
    cu.country,
    COUNT(o.orderID) AS totalOrders
FROM customers cu
JOIN orders o ON cu.customerID = o.customerID
GROUP BY cu.country
ORDER BY totalOrders DESC;
----------------------------------------------------------------------------------------------------------
# Top 3 Most Ordered Products
SELECT 
    p.productName,
    SUM(od.quantity) AS totalOrdered
FROM orderdetails od
JOIN products p ON od.productID = p.productID
GROUP BY p.productName
ORDER BY totalOrdered DESC
LIMIT 3;
----------------------------------------------------------------------------------------------------------
# Top 3 Shippers by Freight and Orders
SELECT 
    s.companyName AS Shipper,
    COUNT(o.orderID) AS TotalOrders,
    SUM(o.freight) AS TotalFreight
FROM 
    orders o
JOIN 
    shippers s ON o.shipperID = s.shipperID
GROUP BY 
    s.companyName
ORDER BY 
    TotalFreight DESC
LIMIT 3;
----------------------------------------------------------------------------------------------------------
# Employees and Who They Report To
SELECT 
    e.employeeName AS Employee,
    m.employeeName AS ReportsTo
FROM 
    employees e
JOIN 
    employees m ON e.reportsTo = m.employeeID;

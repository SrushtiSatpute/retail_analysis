-- Create database

CREATE DATABASE CustomerDB;
USE CustomerDB;

-- Create Customer Table

CREATE TABLE Customer (
Customer_ID INT PRIMARY KEY,
Name VARCHAR(50) NOT NULL,
Email VARCHAR(50) UNIQUE NOT NULL,
Phone VARCHAR(20) NOT NULL,
Age INT NOT NULL,
Gender VARCHAR(12) NOT NULL,
Income VARCHAR(12) NOT NULL,
Customer_Segment VARCHAR(45) NOT NULL
);

-- Create Country Table

CREATE TABLE Country (
Country_ID INT AUTO_INCREMENT PRIMARY KEY,
Name VARCHAR(25) NOT NULL
);

-- Create Address Table

CREATE TABLE Address (
Address_ID INT AUTO_INCREMENT PRIMARY KEY,
Customer_ID INT NOT NULL,
Address TEXT NOT NULL,
City VARCHAR(25) NOT NULL,
State VARCHAR(25),
Zipcode VARCHAR(20),
FOREIGN KEY (Customer_ID) REFERENCES Customer (Customer_ID)
);

-- Create Table Transaction

CREATE TABLE Transaction (
Transaction_ID INT PRIMARY KEY,
Customer_ID INT NOT NULL,
Date DATE NOT NULL,                                    --  Date of the recent purchase
Year INT NOT NULL,                                     --  Year of the recent purchase
Month VARCHAR(20) NOT NULL,                            --  Month of the recent purchase
Time TIME NOT NULL,                                    --  Time of the recent purchase
Total_Purchases INT NOT NULL,                          --  Total number of purchases made
Total_Amount DECIMAL(15,2) NOT NULL,                   --  Total amount spent  by the customer 
FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);

-- Create Table Logistics

CREATE TABLE Logistics (
Logistics_ID INT AUTO_INCREMENT PRIMARY KEY,
Transaction_ID INT NOT NULL,
Shipping_Method VARCHAR(50) NOT NULL,
Payment_Method VARCHAR(50) NOT NULL,
Order_Status VARCHAR(50) NOT NULL,
FOREIGN KEY (Transaction_ID) REFERENCES Transaction(Transaction_ID)
);

-- Create Table Product

CREATE TABLE Product (
Product_ID INT AUTO_INCREMENT PRIMARY KEY,
Transaction_ID INT NOT NULL,
Product_Category VARCHAR(50) NOT NULL,
Product_Brand VARCHAR(50) NOT NULL,
Product_Type VARCHAR(50) NOT NULL,
Products TEXT NOT NULL,
FOREIGN KEY (Transaction_ID) REFERENCES Transaction(Transaction_ID)
);

-- Create Table Feedback

CREATE TABLE Feedback (
Feedback_ID INT AUTO_INCREMENT PRIMARY KEY,
-- Product_ID INT NOT NULL,                        -- add after table inserting data in other columns and then set constraint
Customer_ID INT NOT NULL,
Feedback TEXT NOT NULL,
Ratings INT NOT NULL,
-- FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID),
FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);





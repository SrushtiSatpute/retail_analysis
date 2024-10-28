-- Loading data in respective tables from temp_retail table

-- Inserting data into Customer table from the table Temp_Retail

INSERT INTO Customer (Customer_ID,Name, Email, Phone, Age, Gender, Income, Customer_Segment)
SELECT Customer_ID,Name, Email, Phone, Age, Gender, Income, Customer_Segment
FROM Temp_Retail;

-- Insert data into Country table from table Temp_Retail

INSERT INTO Country (Name)
SELECT Country
FROM Temp_Retail;

-- Insert data into Address table from table Temp_Retail

INSERT INTO Address(Customer_ID,Address,City,State,Zipcode)
SELECT Customer_ID,Address,City,State,Zipcode
FROM Temp_Retail;

-- Add column Country_ID in the Address table without not null

ALTER TABLE ADDRESS 
ADD COLUMN Country_ID INT;

-- Inserting data in the Country_ID column in the Address table

UPDATE Address a
SET a.Country_ID = (
  SELECT c.Country_ID
  FROM Country c
  JOIN Temp_Retail t ON t.Country = c.Name
  WHERE t.Customer_ID = a.Customer_ID
  LIMIT 1
);
-- Modify Country_ID column with Not Null constraint

ALTER TABLE ADDRESS MODIFY  Country_ID INT NOT NULL;

-- Add Foreign Key constraint on Country_ID column in Address table

ALTER TABLE Address ADD FOREIGN KEY(Country_ID) REFERENCES Country(Country_ID);

-- Insert data into Transaction table from Temp_Retail

SET sql_mode = '';                                                       --  disabled strict mode temporarily,this helped to resolve date error 1262 (date = 0000-00-00)

INSERT INTO Transaction(Transaction_ID ,Customer_ID,Date,Year,Month,Time,Total_Purchases,Total_Amount)            
SELECT  DISTINCT Transaction_ID ,Customer_ID, Date,Year,Month,Time,Total_Purchases,Total_Amount
FROM Temp_Retail;

SET sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- Insert data into Logistics table from Temp_Retail

INSERT INTO Logistics(Transaction_ID, Shipping_Method,Payment_Method,Order_Status)            
SELECT Transaction_ID,Shipping_Method,Payment_Method,Order_Status
FROM Temp_Retail;

-- Insert data into Product table from Temp_Retail

INSERT INTO Product(Transaction_ID,Product_Category,Product_Brand,Product_Type,Products)            
SELECT Transaction_ID,Product_Category,Product_Brand,Product_Type,Products
FROM Temp_Retail;

-- Insert data into Feedback table from Temp_Retail

INSERT INTO Feedback(Customer_ID,Feedback,Ratings)            
SELECT Customer_ID,Feedback,Ratings
FROM Temp_Retail;

-- Add column Product_ID in Feedback table without not null

ALTER TABLE Feedback
ADD COLUMN Product_ID INT;

-- Inserting data in Product_ID column in address table(query time = 3.344 )

UPDATE Feedback f
JOIN Temp_Retail t ON f.Customer_ID = t.Customer_ID
JOIN Product p ON t.products = p.products AND t.Transaction_ID = p.Transaction_ID
SET f.Product_ID = p.Product_ID;


-- Modify Product_ID column with Not Null constraint

ALTER TABLE Feedback MODIFY  Product_ID INT NOT NULL;

-- Add Foreign Key constraint on Product_ID column in Feedback table

ALTER TABLE Feedback ADD FOREIGN KEY(Product_ID) REFERENCES Product(Product_ID);

-- After completing data insertion in each and every table drop temp_retail table

DROP TABLE Temp_Retail;


-- DATA Cleaning and Updating

-- Renaming Columns

ALTER TABLE customer
RENAME COLUMN Income TO Income_Group;

ALTER TABLE Product
RENAME COLUMN Products TO Product_Details;

ALTER TABLE Feedback
RENAME COLUMN Feedback TO Reviews;

-- Deleting rows

SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM Country 
WHERE Name = 'Unknown';

DELETE FROM Transaction 
WHERE Month = 'Unknown';

DELETE FROM Address Address_ID
WHERE Country_ID NOT IN (SELECT Country_ID FROM Country);

DELETE FROM Logistics Logistics_ID
WHERE Transaction_ID NOT IN (SELECT Transaction_ID FROM Transaction);

DELETE FROM Product Product_ID
WHERE Transaction_ID NOT IN (SELECT Transaction_ID FROM Transaction);

DELETE FROM Feedback Feedback_ID
WHERE Product_ID NOT IN (SELECT Product_ID FROM Product);

SET FOREIGN_KEY_CHECKS = 1;

-- Updating values

-- Product table

SELECT
COUNT(Product_ID)
FROM Product
WHERE Product_Category = '';
-- WHERE Product_Brand = '';

UPDATE Product
SET Product_Category = 'Unknown'
WHERE Product_Category = '';

UPDATE Product
SET Product_Brand = 'Unknown'
WHERE Product_Brand = '';

-- Feedback table

SELECT
Feedback_ID
FROM Feedback
WHERE Feedback = '';
-- WHERE Ratings = '';

UPDATE Feedback
SET Ratings = 0
WHERE Ratings = '';

UPDATE Feedback
SET Reviews = 'Unknown'
WHERE Reviews = '';

-- Transaction table

SELECT 
Transaction_ID
FROM Transaction
WHERE Total_Amount = '';
-- WHERE Total_Purchases = '';

UPDATE Transaction
SET Total_Purchases  = 0
WHERE Total_Purchases = '';

UPDATE Transaction
SET Total_Amount  = 0.00
WHERE Total_Amount = '';

-- Logistics table

SELECT 
Logistics_ID
FROM Logistics
WHERE Order_Status = '';
-- WHERE Shipping_Method = '';
-- WHERE Payment_Method = '';

UPDATE Logistics
SET Order_Status = 'Unknown'
WHERE Order_Status = '';

UPDATE Logistics
SET Payment_Method = 'Unknown'
WHERE Payment_Method = '';

UPDATE Logistics
SET Shipping_Method = 'Unknown'
WHERE Shipping_Method = '';

-- Customer table

SELECT 
Customer_Id
FROM customer
WHERE Name = '';              -- name,email,phone,age,gender,income_group,customer_segment

UPDATE Customer
SET Name = 'Unknown'
WHERE Name = '';

UPDATE Customer
SET Email = 'Unknown'
WHERE Email = '';

UPDATE Customer
SET Age = 0
WHERE Age = '' ;

UPDATE Customer
SET Customer_Segment = 'Unknown'
WHERE Customer_Segment = '';

UPDATE Customer
SET Phone = 'Unknown'
WHERE Phone = '';

UPDATE Customer
SET Gender = 'Unknown'
WHERE Gender = '';

UPDATE Customer
SET Income_Group = 'Unknown'
WHERE Income_Group = '';

-- Address table

SELECT
Address_ID
FROM Address
WHERE Address = '';                       -- address,city,state,zipcode

UPDATE Address
SET Address = 'Unknown'
WHERE Address = '';

UPDATE Address
SET City = 'Unknown'
WHERE City = '';

UPDATE Address
SET State = 'Unknown'
WHERE State = '';

UPDATE Address
SET Zipcode = 'Unknown'
WHERE Zipcode = '';

















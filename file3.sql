-- Data Cleaning of Temp_Retail table before data insertion in respective tables

SELECT * FROM customerdb.temp_retail;

-- Deleted  record Where customer_id was zero

DELETE FROM customerdb.temp_retail WHERE Customer_ID = 0 AND Transaction_ID = 9076126;

-- After importing the data to mysql finding the number of records where a) Month name != month in date column b) Year != year in date
-- Found 4596 records with conition a and 100 records with condition b

SELECT
COUNT(Customer_ID)
FROM customerdb.temp_retail
WHERE 1=1
-- AND MONTHNAME(Date) != Month 
AND YEAR(Date) != Year;

-- Deleting month and year columns

ALTER table temp_retail
DROP COLUMN Year,
DROP COLUMN Month;

-- Adding month and year columns

ALTER table temp_retail
ADD COLUMN Month VARCHAR(20) AFTER Date,
ADD COLUMN Year INT AFTER Month;

-- Updating values of month and year column

UPDATE temp_retail
SET Month = MONTHNAME(Date),
    Year = YEAR(Date);

-- Checking for null values in date column

SELECT COUNT(*) FROM Temp_Retail WHERE Date IS NULL LIMIT 50000;     -- 57 rows with '0000-00-00'

-- Checking for duplicate transaction entry which prevents data insertion and deleting duplicates (115 rows)

DELETE FROM Temp_Retail
WHERE Transaction_ID IN
(
SELECT Transaction_ID 
FROM (
SELECT Transaction_ID
FROM Temp_Retail
GROUP BY Transaction_ID
HAVING COUNT(*) > 1) as duplicate
);

-- Checking month column for null values

SELECT COUNT(*) FROM Temp_Retail WHERE Month IS NULL LIMIT 50000;     

-- Updating month column for null values

UPDATE Temp_Retail
SET Month = 'Unknown'     
WHERE Month IS NULL;








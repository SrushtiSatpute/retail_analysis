-- Retail Transactional data analysis

-- Choose database CustomerDB

-- Data Exploration
-- 1) General overview of tables

SELECT * FROM Customer;            -- 45809 rows 
SELECT * FROM Country;             -- 45776 rows
SELECT * FROM Address;             -- 45776 rows
SELECT * FROM Transaction;         -- 45475 rows
SELECT * FROM Product;             -- 45475 rows 
SELECT * FROM Logistics;           -- 45475 rows
SELECT * FROM Feedback;            -- 45475 rows


-- 2) Data types and structure of each table

DESCRIBE Customer;
DESCRIBE Address;
DESCRIBE Country;
DESCRIBE Transaction;
DESCRIBE Logistics;
DESCRIBE Product;
DESCRIBE Feedback; 

-- a) What is the average age of the customer?                   

SELECT
ROUND(AVG(Age),0) as avg_age
FROM Customer;

-- b) Show distinct countries in the country table.               

SELECT
DISTINCT Name
FROM Country;

-- c) Display the total number of customers in the customer table.                                 

SELECT
COUNT(Customer_ID) as customer_count
FROM Customer;

-- d) Show distinct product categories in the product table.            

SELECT
DISTINCT Product_Category
FROM Product;

-- e) What is the total amount that customers have spent on each product category?               

SELECT
p.Product_Category,
ROUND(SUM(Total_Amount),0)  as total_spend_by_category
FROM  Transaction t
JOIN Product p
ON t.Transaction_ID = p.Transaction_ID 
GROUP BY p.Product_Category
ORDER BY total_spend_by_category DESC;

-- f) Identify the customer segment that generates the highest revenue.               

SELECT
Customer_Segment,
ROUND(SUM(Total_Amount),0) as total_revenue
FROM Customer c
JOIN Transaction t
ON c.Customer_ID = t.Customer_ID
GROUP BY Customer_Segment
ORDER BY total_revenue DESC
LIMIT 1;

-- g) What is the running total of sales for each customer over the past year?

SELECT
Customer_ID,
Date,
ROUND(SUM(Total_Amount) OVER(PARTITION BY Customer_ID ORDER BY Date),0) as running_total_sales
FROM Transaction
WHERE Year = YEAR(CURDATE()) - 1;

-- h) How do product category sales vary over seasons in different countries, including Australia's seasonal calendar?

SELECT
co.Name,
p.Product_Category,
CASE
 WHEN co.Name = 'Australia' AND Month IN ('September','October','November') THEN 'Spring'
 WHEN co.Name = 'Australia' AND Month IN ('December','January','February') THEN 'Summer'
 WHEN co.Name = 'Australia' AND Month IN ('March','April','May') THEN 'Autumn'
 WHEN co.Name = 'Australia' AND Month IN ('June','July','August') THEN 'Winter'
ELSE
CASE
  WHEN Month IN ('March','April','May') THEN 'Spring'
  WHEN Month IN ('June','July','August') THEN 'Summer'
  WHEN Month IN ('September','October','November') THEN 'Autumn'
  WHEN Month IN ('December','January','February') THEN 'Winter'
END
END as Season,
ROUND(SUM(Total_Amount),0) as Total_Sales
FROM Country co 
JOIN Address a 
ON co.Country_ID = a.Country_ID
JOIN Customer c 
ON a.Customer_ID = c.Customer_ID
JOIN Transaction t 
ON  c.Customer_ID = t.Customer_ID 
JOIN Product p
ON p.Transaction_ID = t.Transaction_ID
GROUP BY co.Name,p.Product_Category,Season
ORDER BY Total_Sales DESC;

-- i) Find the total amount spent on different types of products,across different dates and categories, as well as the overall total?

SELECT
Date,
COALESCE(Product_Category, 'All Categories') as category,
ROUND(SUM(Total_Amount),0) as total
FROM Product p
JOIN Transaction t 
ON p.Transaction_ID = t.Transaction_ID 
GROUP BY Date,Product_Category
WITH ROLLUP;

-- j) Calculate the average amount spent per transaction for cash and for PayPal

SELECT
ROUND(AVG(CASE WHEN Payment_Method = 'Cash' THEN Total_Amount END),2) as avg_cash_transactions,             
ROUND(AVG(CASE WHEN Payment_Method = 'PayPal' THEN Total_Amount  END),2) as avg_paypal_transactions            
FROM Logistics l
JOIN Transaction t 
ON l.Transaction_ID = t.Transaction_ID;

-- k) How does the mode of payment affect the status of the order?

SELECT
Payment_Method,
Order_Status,
COUNT(Logistics_ID) as Order_Count
FROM Logistics
GROUP BY Payment_Method,Order_Status;

-- l) Which product category has the highest average rating based on customer feedback?          

SELECT
Product_Category as category,
ROUND(AVG(Ratings),1) as avg_rating
FROM Feedback f
JOIN Product p 
ON f.Product_ID = p.Product_ID
GROUP BY category
ORDER BY avg_rating DESC
LIMIT 1;











 





















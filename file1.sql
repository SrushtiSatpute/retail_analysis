-- Create temp table to import data from csv to mysql

CREATE TABLE Temp_Retail (
Transaction_ID INT NOT NULL,
Customer_ID INT PRIMARY KEY,
Name  VARCHAR(50) NOT NULL,
Email VARCHAR(50) UNIQUE NOT NULL,
Phone VARCHAR(20) NOT NULL,
Address TEXT NOT NULL,
City VARCHAR(25) NOT NULL,
State VARCHAR(25),
Zipcode VARCHAR(20),
Country VARCHAR(25) NOT NULL,
Age INT NOT NULL,
Gender VARCHAR(12) NOT NULL,
Income VARCHAR(12)NOT NULL,
Customer_Segment VARCHAR(45) NOT NULL,
Date DATE NOT NULL,   -- Date shall be in yyyy/mm/dd format in csv before the file is being imported to mysql                           
Year INT NOT NULL,                              
Month VARCHAR(20) NOT NULL,                             
Time TIME NOT NULL,      
Total_Purchases INT NOT NULL,
Amount DECIMAL(15,2) NOT NULL,                   
Total_Amount DECIMAL(15,2) NOT NULL,  
Product_Category VARCHAR(50) NOT NULL,
Product_Brand VARCHAR(50) NOT NULL,
Product_Type VARCHAR(50) NOT NULL,
Feedback TEXT NOT NULL,
Shipping_Method VARCHAR(50) NOT NULL,
Payment_Method VARCHAR(50) NOT NULL,
Order_Status VARCHAR(50) NOT NULL,
Ratings INT NOT NULL,
Products TEXT NOT NULL
 );
 
 -- Load data from csv to mysql
 
LOAD DATA LOCAL INFILE 'C:/Users/Asus/OneDrive/Desktop/data/retail_data.csv'    -- path where the file is situated on user desktop
INTO TABLE Temp_Retail
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


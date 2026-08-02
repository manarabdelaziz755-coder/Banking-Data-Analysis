create database Banking

-----------Data Exploration-----------------------
------------How many records are there in each table?---------------
select count(*) from customer_data
select count(*) from transaction_data
select count(*) from bank_data

-----------What are the columns and data types of each table------------------------
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Customer_data';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'transaction_data';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'bank_data';

----------------How many missing values exist in each column---------------------------------
select count(*) as Total_Rows,
sum(case when Age is null then 1 else 0 end) as missing_age,
sum(case when Customer_Type is null then 1 else 0 end) as missing_CT,
sum(case when City is null then 1 else 0 end) as missing_city,
sum(case when Region is null then 1 else 0 end) as missing_Region
from customer_data

select count(*) as Total_Rows,
sum(case when Account_Type is null then 1 else 0 end) as missing_AT,
sum(case when Total_Balance is null then 1 else 0 end) as missing_Total_balance,
sum(case when Transaction_Amount is null then 1 else 0 end) as missing_TA,
sum(case when Investment_Amount is null then 1 else 0 end) as missing_IA,
sum(case when Investment_Type is null then 1 else 0 end) as missing_IT
from transaction_data

select count(*) as Total_Rows,
sum(case when City is null then 1 else 0 end) as missing_city,
sum(case when Region is null then 1 else 0 end) as missing_Region,
sum(case when Firm_Revenue is null then 1 else 0 end) as missing_FR,
sum(case when Expenses is null then 1 else 0 end) as missing_Expenses,
sum(case when Profit_Margin is null then 1 else 0 end) as missing_PM
from bank_data

---------------------------------------------------------------------
SELECT PERCENTILE_CONT(0.5) 
WITHIN GROUP (ORDER BY Age) OVER () AS Median_Age
FROM customer_data;

UPDATE customer_data
SET Age = 49 
WHERE Age IS NULL;

UPDATE customer_data
SET City = 'Unknown' 
WHERE City IS NULL;

SELECT TOP 1
    Customer_Type,
    COUNT(*) AS Total
FROM customer_data
WHERE Customer_Type IS NOT NULL
GROUP BY Customer_Type
ORDER BY Total DESC;

UPDATE customer_data
SET Customer_Type = 'Business' 
WHERE Customer_Type IS NULL;

SELECT PERCENTILE_CONT(0.5)
WITHIN GROUP (ORDER BY Firm_Revenue) OVER () AS Median_Revenue
FROM bank_data;

UPDATE bank_data
SET Firm_Revenue = 518348.5 
WHERE Firm_Revenue IS NULL;
-----------------Duplicate Check----------------------------------------------------
select Customer_ID,Age,Customer_Type,City,Region,
Bank_Name,Branch_ID,count(*) as Duplicate_Count
from customer_data
group by Customer_ID,Age,Customer_Type,City,Region,
Bank_Name,Branch_ID
having count(*) >1;

select Transaction_ID,Customer_ID,Account_Type,Total_Balance,Transaction_Amount,
Investment_Amount,Investment_Type,Transaction_Date,count(*) as Duplicate_Count
from transaction_data
group by Transaction_ID,Customer_ID,Account_Type,Total_Balance,Transaction_Amount,
Investment_Amount,Investment_Type,Transaction_Date
having count(*) >1;

select Branch_ID,City,Region,Firm_Revenue,Expenses,Profit_Margin,
count(*) as Duplicate_Count
from bank_data
group by Branch_ID,City,Region,Firm_Revenue,Expenses,Profit_Margin
having count(*) > 1;

------------------------Distinct Values----------------------------------------------
select count(distinct Customer_ID) from customer_data;
select count(distinct Transaction_ID) from transaction_data;
select count(distinct Branch_ID) from bank_data;

------------------------------------------------------------------------
select Distinct Investment_Type from transaction_data;
select Distinct Customer_Type from customer_data;
---------------------------Investment Analysis-----------------------------------------------
-------------------What is the distribution of investment types
select Investment_Type,count(*) as total
from transaction_data
group by Investment_Type
order by total DESC;
-------------------Minimum, Maximum, Average--------------------------------------
select MIN(Investment_Amount) as min_amount,
MAX(Investment_Amount) as max_amount,
AVG(Investment_Amount) as avg_amount
from transaction_data

-------------------------Customer Analysis---------------------------------
------------------Minimum, Maximum, Average
select MIN(Age) as min_Age,
max(Age) as max_Age ,
avg(Age) as avg_Age
from customer_data
------------------Who are the most active customers----------------------------------------
select top 10 Customer_ID,count(*) as Transactions_Count
from transaction_data
group by Customer_ID
order by Transactions_Count DESC;

---------------------Time Analysis-----------------------------------
-----------How many transactions occurred each month?
select MONTH(Transaction_Date) as month_number,
count(*) as Total_Transactions
from transaction_data
group by month(Transaction_Date)
order by Total_Transactions DESC;

---------------------------------------------------------
select top 10 * from transaction_data
order by Transaction_Amount DESC;


-----------------Top 10 Customers by Total Transaction Amount-----------
select top 10 c.Customer_ID,c.Customer_Type,
sum(t.Transaction_Amount) as Total_Transaction_Amount
from customer_data as c
join transaction_data as t
on c.Customer_ID=t.Customer_ID
group by c.Customer_ID,c.Customer_Type
order by Total_Transaction_Amount DESC;

----------------How many transactions does each customer make?----------------------------
select Customer_ID,count(Transaction_ID) as Number_of_Transactions
from transaction_data
group by Customer_ID;

------------------Who are the most active customers-----------------
select Customer_ID,count(Transaction_ID) as Number_of_Transactions
from transaction_data
group by Customer_ID
order by Number_of_Transactions DESC;

------------What is the total transaction amount---------------
select sum(Transaction_Amount) as Total_Transaction_Amount
from transaction_data
------------------What is the average transaction amount----------
select avg(Transaction_Amount) as avg_Transaction_Amount
from transaction_data

--------------What are the highest-value transactions?-------------
select top 10 Transaction_ID,Customer_ID, Transaction_Amount,
Transaction_Date
from transaction_data
order by Transaction_Amount DESC;

------------What is the total investment amount---------
select sum(Investment_Amount) as Total_Investment_Amount
from transaction_data

---------------Which investment type is most popular------------
select Investment_Type, count(*) as Number_of_Investments
from transaction_data
group by Investment_Type
order by Number_of_Investments DESC;

------------What is the average investment amount-----------
select avg(Investment_Amount) as avg_Investment_Amount
from transaction_data;

---------------------Rank customers based on their total transaction amount--------------------------------------
select Customer_ID,sum(Transaction_Amount) as total_amount,
RANK() over(order by sum(Transaction_Amount) DESC) as customer_rank
from transaction_data
group by Customer_ID;

------------------------Classify customers into High, Medium, and Low Value.-----------------------------
select Customer_ID,sum(Transaction_Amount) as total_amount,
   case when sum(Transaction_Amount)>= 15000 then 'High Value'
   when sum(Transaction_Amount)>=800 then 'Medium Value'
   else 'Low Value'
end as Customer_Category
from transaction_data
group by Customer_ID

---------------------Find customers whose total transactions are above the average------------
select Customer_ID,sum(Transaction_Amount) as total_amount
from transaction_data
group by Customer_ID
having sum(Transaction_Amount)>
(select avg(Transaction_Amount) from transaction_data)

-------------------Calculate the running total of transaction amounts over time------------
select Transaction_Date,Transaction_Amount,
sum(Transaction_Amount) over (order by Transaction_Date) as Running_Total
from transaction_data

----------------------Calculate the running total of transaction amounts over time ---------------------------
WITH Customer_Summary AS
(
    SELECT
        Customer_ID,
        SUM(Transaction_Amount) AS Total_Amount
    FROM transaction_data
    GROUP BY Customer_ID
)
SELECT TOP 5 *
FROM Customer_Summary
ORDER BY Total_Amount DESC;

-------------------Divide customers into four groups based on transaction amount------------
select Customer_ID,sum(Transaction_Amount) as total_amount,
NTILE(4) over(order by sum (Transaction_Amount)DESC) as Customer_Group
from transaction_data
group by Customer_ID;

------------------Compare each transaction with the previous and next transaction---------------------
select Transaction_ID,Transaction_Date,Transaction_Amount,
LAG(Transaction_Amount)
over(order by Transaction_Date) as  Previous_Transaction,
LEAD(Transaction_Amount)
over(order by Transaction_Date) as Next_Transaction

from transaction_data

-----------------------Which branch has the highest profit margin?---------------------------
select top 1 branch_id,Profit_Margin
from bank_data
order by Profit_Margin DESC;

---------------------------Create a view to summarize customer transactions---------------------------------------
CREATE VIEW Customer_Analysis AS

SELECT
    c.Customer_ID,
    c.Customer_Type,
    c.City,
    t.Account_Type,
    SUM(t.Transaction_Amount) AS Total_Transaction

FROM customer_data c

JOIN transaction_data t
ON c.Customer_ID = t.Customer_ID

GROUP BY
    c.Customer_ID,
    c.Customer_Type,
    c.City,
    t.Account_Type;
select * from Customer_Analysis

---------------------Top 3 Customers per Region----------------
WITH Customer_Transactions AS
(
    SELECT
        c.Region,
        c.Customer_ID,
        SUM(t.Transaction_Amount) AS Total_Transaction
    FROM customer_data c
    JOIN transaction_data t
        ON c.Customer_ID = t.Customer_ID
    GROUP BY
        c.Region,
        c.Customer_ID
),

Ranked_Customers AS
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY Region
               ORDER BY Total_Transaction DESC
           ) AS RN
    FROM Customer_Transactions
)

SELECT *
FROM Ranked_Customers
WHERE RN <= 3;

---------Calculate each customer's contribution percentage to the bank's total transaction amount.-------------
SELECT
    Customer_ID,
    SUM(Transaction_Amount) AS Total_Transaction,

    ROUND(
        SUM(Transaction_Amount) * 100.0 /
        (SELECT S UM(Transaction_Amount)
         FROM transaction_data),2
    ) AS Contribution_Percentage

FROM transaction_data
GROUP BY Customer_ID
ORDER BY Contribution_Percentage DESC;



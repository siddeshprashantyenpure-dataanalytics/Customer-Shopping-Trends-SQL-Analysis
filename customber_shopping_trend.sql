-- Step 1 : Create Database and Load data into it and show table structure.

create database shopping_Trend;
use shopping_Trend; 
describe shopping_trends;

-- =====================================================================================================================================================================================================================
-- Step 2 : Data Cleaning 

-- 1.Rename Columns in required format
alter table shopping_trends change `Transaction ID` Transaction_ID text;
alter table shopping_trends change `Customer ID` Customer_ID text;
alter table shopping_trends change `Purchase Date` Purchase_Date text;
alter table shopping_trends change `Online Store` Online_Store text;
alter table shopping_trends change `Purchase Amount (â‚¹)` Purchase_Amount int;
alter table shopping_trends change `Discount (%)` Discount int;
alter table shopping_trends change `Shipping Charge (â‚¹)` Shipping_Charge int;
alter table shopping_trends change `Delivery Speed` Delivery_Speed text;alter table shopping_trends change `Delivery Time (Days)` Delivery_Time_Days int;
alter table shopping_trends change `Subscription Status` Subscription_Status text;
alter table shopping_trends change `Review Rating` Review_Rating int;
alter table shopping_trends change `Return Status` Return_Status text;
alter table shopping_trends change `Previous Purchases` Previous_Purchases int;
alter table shopping_trends change `Frequency of Purchases` Frequency_of_Purchases text;
alter table shopping_trends change `Payment Method` Payment_Method text;
alter table shopping_trends change `Item Purchased` Item_Purchased text;
alter table shopping_trends change `Online/Offline` Online_Offline text;
alter table shopping_trends change `Festival/Sale` Festival_Sale text;

update shopping_trends set Delivery_Speed = 'Instant(Offline)' where Delivery_Speed = ' '; 

-- 2.Change Column Types as required
alter table shopping_trends modify Purchase_Date date;

-- 3.Find Missing and Null Values
select count(Transaction_ID) as Total_Transactions
from shopping_trends 
where Transaction_ID is not null and trim(Transaction_ID) != '';

-- 4.Find Duplicate Values
select Transaction_ID,
count(*) as Total_Transactions
from shopping_trends
group by Transaction_ID
having Total_Transactions > 1 ;

-- 5. Check Unique Values
select distinct(Gender) as Unique_Gender from shopping_trends;
select distinct(Frequency_of_Purchases) as Unique_Frequency_of_Purchases from shopping_trends;
select distinct(Category) as Category from shopping_trends;
select distinct(Brand) as Unique_Brand from shopping_trends;
select distinct(Payment_Method) as Unique_Payment_Method from shopping_trends;

-- ================================================================================================================================================================================================================================================================ 
-- Step 3 : Data Exploration

-- 1.Total Records
select count(*) as Total_Records 
from shopping_trends;

-- 2.Average Age
select round(avg(Age)) as Average_Age 
from shopping_trends;

-- 3.Total Customers
select count(distinct Customer_ID) as Total_Customers from shopping_trends;

-- 4.Average Spendings
select round(avg(Purchase_Amount)) as Average_Spendings from shopping_trends;

-- ====================================================================================================================================================================================================================================
-- Step 4 : Business Analysis

-- A.Customer Analysis
-- Average Age
select round(avg(Age)) as Average_Age 
from shopping_trends;

-- Top 5 Spending Customers
select Customer_ID,sum(Purchase_Amount) as Top_5_Spending_Customer
from shopping_trends 
group by Customer_ID
order by Top_5_Spending_Customer desc
limit 5;

-- Customer Lifetime Spend
select Customer_ID,sum(Purchase_Amount) as Customer_Lifetime_Spending
from shopping_trends 
group by Customer_ID;

-- Top 10 Repeat Customers
select Customer_ID,count(Transaction_ID) as Repeated_Customers
from shopping_trends
group by Customer_ID
order by Repeated_Customers desc
limit 10;

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- B.Sales Analysis

-- 1.Total Revenue
select sum(Purchase_Amount) as Total_Revenue 
from shopping_trends;

-- 2.Average Order Value
select round(sum(Purchase_Amount) / count(Transaction_ID),2) as Average_Order_Value
from shopping_trends; 

-- 3.Highest Order
select Purchase_Amount as Highest_Order_Price
from shopping_trends
order by Purchase_Amount desc
limit 1;

-- 4.Lowest Order
select Purchase_Amount as Lowest_Order_Price
from shopping_trends
order by Purchase_Amount
limit 1;

-- 5.Monthly Revenue Overall
select monthname(Purchase_Date)as Month,sum(Purchase_Amount) as Monthly_Revenue_Overall
from shopping_trends
group by monthname(Purchase_Date)
order by month(Purchase_Date);

-- 6.Monthly Revenue Yearly
select monthname(Purchase_Date),year(Purchase_Date),sum(Purchase_Amount) as Monthly_Revenue_Yearly
from shopping_trends 
group by month(Purchase_Date),year(Purchase_Date)
order by year(Purchase_Date),month(Purchase_Date);

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- C.Product Analysis

-- 1.Best Selling Category
select Category,Count(Category) as Best_Selling_Category
from shopping_trends
group by Category
order by Best_Selling_Category desc
limit 1;

-- 2.Best Selling Item
select Item_Purchased,count(Item_Purchased) as Best_Selling_Item
from shopping_trends
group by Item_Purchased
order by Best_Selling_Item desc
limit 1;

-- 3.Least Selling 
select Item_Purchased,count(Item_Purchased) as Least_Selling_Item
from shopping_trends
group by Item_Purchased
order by Least_Selling_Item
limit 1;

-- 4.Quantity Sold
select Item_Purchased as Item,count(Item_Purchased) as Quantity_Sold
from shopping_trends
group by Item_Purchased
order by Quantity_Sold desc;

-- 5.Brand Performance
select Brand,round(sum(Review_Rating)/count(Review_Rating),2) as Rating
from shopping_trends
group by Brand
order by Rating desc;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- D.Location Analysis

-- 1.Revenue by Location
select Location,sum(Purchase_Amount) as Revenue_By_Location
from shopping_trends
group by Location
order by Revenue_By_Location desc;

-- 2.State Wise Brand Choices
select Location,count(distinct Brand) as Total_Brands
from shopping_trends
group by Location
order by Total_Brands;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- E.Discount Analysis
-- 1.Revenue with Discount
select round(sum(Purchase_Amount - ((Discount/100)*Purchase_Amount))) as Revenue_With_Discount from shopping_trends;

-- 2.Revenue without Discount\
select sum(Purchase_Amount) as Revenue_Without_Discount from shopping_trends;

-- 3.Average Discount on only discounted orders
select round(sum(Discount)/Count(Discount),2) as Average_Discount_On_Discounted_Orders from shopping_trends where Discount != 0;

-- 4.Average Discount on all orders
select round(sum(Discount)/Count(Discount),2) as Average_Discount_On_All_Orders from shopping_trends;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- F.Payment Analysis
-- 1.Most Used Payment Method
select Payment_Method,count(Payment_Method) Most_Used_Payment_Method
from shopping_trends
group by Payment_Method
order by Most_Used_Payment_Method desc;

-- 2.Revenue by Payment Method
select Payment_Method,sum(Purchase_Amount) as Revenue_By_Payment_Method
from shopping_trends
group by Payment_Method
order by Revenue_By_Payment_Method desc;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- G.Shipping Analysis
-- 1.Shipping Type Distribution
select Delivery_Speed,count(Delivery_Speed) as Distribution
from shopping_trends
group by Delivery_Speed
order by Distribution desc;

-- 2.Fastest Shipping
select Delivery_Speed,Delivery_Time_Days 
from shopping_trends
where Delivery_Speed != 'Instant(Offline)'
group by Delivery_Speed
order by Delivery_Time_Days asc
limit 1;

-- 3.Revenue by Shipping Type
select Delivery_Speed,sum(Purchase_Amount) as Revenue
from shopping_trends
group by Delivery_Speed
order by Revenue desc;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- H.Customer Behaviour
-- 1.Online vs Offline Per Transaction Value
select distinct(select round(avg(Purchase_Amount),2) from shopping_trends as Online_Average where Online_Offline = 'Online') as Online_Average,
(select round(avg(Purchase_Amount),2) from shopping_trends as Online_Average where Online_Offline = 'Offline') as Offline_Average
from shopping_trends;

-- 2.Shopping Frequency
select Frequency_of_Purchases Purchases,count(Frequency_of_Purchases) as Frequency
from shopping_trends
group by Frequency_of_Purchases
order by Frequency desc;

-- 3.Subscription Status
select round((select count(Subscription_Status) from shopping_trends where Subscription_Status = 'Yes')/count(Subscription_Status)*100,2) as Subscription_Percent
from shopping_trends;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- I.CASE Statement
-- 1.Classify customers as Young (18–30), Middle-aged (31–50), and Senior (51+).
select Age,
case
	when Age between 18 and 30 then 'Young'
    when Age between 31 and 50 then 'Middle-Aged'
    when Age >= 51 then 'Senior'
end as  Age_Classification
from shopping_trends;

-- 2.Categorize orders into Low, Medium, and High Value based on Purchase_Amount.
select Purchase_Amount,
case 
	when Purchase_Amount <= 1000 then 'Low'
    when Purchase_Amount between 1001 and 5000 then 'Medium'
    when Purchase_Amount >= 5000 then 'High'
end as Cost_Classification
from shopping_trends;

-- 3.Show whether a customer received a Discount or No Discount.
select Customer_ID,Transaction_ID,
case 
	when  Discount = 0 then 'No Discount'
    when Discount != 0 then 'Discount'
end as Discount_Classification
from shopping_trends
order by Transaction_ID;

-- 4.Categorize customers as Frequent, Occasional, or Rare shoppers using Frequency_of_Purchases.
select distinct Customer_ID, 
case 
	when Frequency_of_Purchases = 'Fortnightly' then 'Frequent'
    when Frequency_of_Purchases = 'Weekly' then 'Frequent'
    when Frequency_of_Purchases = 'Rarely' then 'Rare'
    when Frequency_of_Purchases = 'Monthly' then 'Occasional'
    when Frequency_of_Purchases = 'Quarterly' then 'Occasional'
end as Purchase_Classification
from shopping_trends;

-- 5.Create a column showing Large Order if Quantity >= 3, otherwise Small Order.
select Transaction_ID,
case
	when Quantity < 3 then 'Small Quantity'
    when Quantity >= 3 then 'Large Quantity'
end as Quantity_Classification
from shopping_trends;

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- J.Aggregate + CASE
-- 1.Count how many High, Medium, and Low Value orders exist.
select 
	sum(case when Purchase_Amount < 1000 then 1 else 0 end) as 'Low Value Order',
    sum(case when Purchase_Amount between 1000 and 5000 then 1 else 0 end) as 'Medium Value Order',
    sum(case when Purchase_Amount > 5000 then 1 else 0 end) as 'High Value Order'
from shopping_trends;

-- 2.Compare average purchase amount between Online and Offline shoppers.
select 
	round(sum(case when Online_Offline = 'Online' then Purchase_Amount else 0 end)/count(case when Online_Offline = 'Online' then 1 else 0 end),2) as Online_Average,
    round(sum(case when Online_Offline = 'Offline' then Purchase_Amount else 0 end)/count(case when Online_Offline = 'Offline' then 1 else 0 end),2) as Offline_Average
from shopping_trends;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- K.HAVING
-- 1.Show category whose revenue exceeds ₹50,00,000.
select Category,sum(Purchase_Amount) as Revenue
from shopping_trends
group by Category
having Revenue > 5000000;

-- 2.Find brands that sold more than 1200 items.
select Brand,sum(Quantity) as Units_Sold
from shopping_trends
group by Brand
having Units_Sold > 1200;

-- 3.Display cities having more than 500 customers.
select Location,count(Customer_ID) as Customers
from shopping_trends 
group by Location
having Customers > 500;

-- 4.Find customers whose lifetime spending exceeds ₹15,000.
select Customer_ID,sum(Purchase_Amount) as Lifetime_Spendings_Above_15000
from shopping_trends
group by Customer_ID
having Lifetime_Spendings_Above_15000 > 15000;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- L.Subqueries
-- 1.Find customers whose purchase amount is above the overall average.
select Customer_ID,Purchase_Amount
from shopping_trends
where Purchase_Amount > (select avg(Purchase_Amount) from shopping_trends);

-- 2.Find the item with the highest purchase amount.
select Item_Purchased,Purchase_Amount 
from shopping_trends
where Purchase_Amount = (select max(Purchase_Amount) from shopping_trends);

-- 3.Show customers who spent more than the average customer spending.
select Customer_ID,sum(Purchase_Amount) as Spending
from shopping_trends
group by Customer_ID
having Spending  > (
		select avg(Spending) 
        from (  select sum(Purchase_Amount) as Spending 
				from shopping_trends 
                group by Customer_ID) as Customer_Spending
);

-- 4.Find brands whose revenue is greater than the average brand revenue.
select Brand,sum(Purchase_Amount) as Revenue
from shopping_trends
group by Brand
having Revenue > (
		select avg(Revenue)
		from (	select sum(Purchase_Amount) as Revenue 
				from  shopping_trends 
				group by Brand
			 ) as Average_Brand_Revenue
);

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- M.Correlated Subqueries
-- 1.Find the highest purchase in each category.
select Category,max(Purchase_Amount) as Highest_Purchase
from shopping_trends
group by Category;

-- 2.Find customers who made the largest purchase in their city.
select Customer_ID,Location,Purchase_Amount
from (
		select Location,Customer_ID,(Purchase_Amount),
		rank() over(partition by Location order by Purchase_Amount desc) as rnk
		from shopping_trends
) as Location_Rankings
where rnk = 1;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- N.CTE
-- 1.Create a CTE to calculate total spending per customer.
with Spending_Per_Customer as(
	select Customer_ID,sum(Purchase_Amount) as Total_Spending
    from shopping_trends
    group by Customer_ID
)

select * from Spending_Per_Customer;

-- 2.Using that CTE, display the Top 10 customers.
with Spending_Per_Customer as(
	select Customer_ID,sum(Purchase_Amount) as Spending
    from shopping_trends
    group by Customer_ID
)

select Customer_ID,Spending
from Spending_Per_Customer 
order by Spending desc
limit 10;

-- 3.Calculate total revenue per Month using a CTE.
with Monthly_Revenue as(
	Select Year(Purchase_Date) as Year,monthname(Purchase_Date) as Month,sum(Purchase_Amount) as Revenue 
    from shopping_trends
    group by Year(Purchase_Date),Month(Purchase_Date)
)

select Year,Month,Revenue from Monthly_Revenue;

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- O.String Functions
-- 1.Display customer IDs in uppercase.
select upper(Customer_ID) from shopping_trends;

-- 2.Count customers by the first letter of their location.
select left(Location,1) as First_Letter,count(distinct Customer_ID) as Customer
from shopping_trends
group by First_Letter;

-- 3.Remove leading/trailing spaces from text columns.
select
	trim(Customer_ID) as ID,
	trim(Gender) as Gender,
	trim(Location) as Location, 
	trim(Online_Offline) as Online_Offline,
	trim(Online_Store) as Store,
	trim(Category) as Category,
	trim(Item_Purchased) as Item_Purchased,
	trim(Brand) as Brand,
	trim(Color) as Color, 
	trim(Size) as Size,
	trim(Festival_Sale) as Festival_Sale,
	trim(Delivery_Speed) as Speed, 
	trim(Subscription_Status) as Subscription_Status,
	trim(Payment_Method) as Payment_Method,
	trim(Return_Status) as Return_Status,
	trim(Frequency_of_Purchases) as Freq
from shopping_trends;

-- 4.Display item names along with their character length.
select distinct Item_Purchased,length(Item_Purchased) as Length
from shopping_trends;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- P.ROW_NUMBER()
-- 1.Number all transactions based on purchase date.
select Transaction_ID,
row_number() over(order by Purchase_Date) as Transaction_Number
from shopping_trends;

-- 2.Number customers within each location according to purchase amount.
select Customer_ID,Location,Purchase_Amount,
row_number() over(partition by Location order by Purchase_Amount desc) as Customer_Number
from shopping_trends;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Q.RANK()
-- 1. Rank categories by total revenue.
select distinct Category,sum(Purchase_Amount) as Revenue,
rank() over(order by sum(Purchase_Amount) desc) as `Rank`
from shopping_trends
group by Category
order by `Rank`;

-- 2. Rank brands by total quantity sold.
select Brand,sum(Quantity) as Units_Sold,
rank() over(order by sum(Quantity) desc) as Brand_Number
from shopping_trends
group by Brand
order by Brand_Number;

-- 3. Rank cities by total sales.
select Location,sum(Purchase_Amount) as Total_Sales,
rank() over(order by sum(Purchase_Amount) desc) as `Order`
from shopping_trends
group by Location
order by `Order`; 

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- R.DENSE_RANK()
-- 1.Dense rank customers by lifetime spending.
select Customer_ID,sum(Purchase_Amount) as Lifetime_Spending,
dense_rank() over(order by sum(Purchase_Amount) desc) as DENSE_RANK_SPENDING
from shopping_trends
group by Customer_ID
order by DENSE_RANK_SPENDING;

-- 2.Dense rank payment methods by revenue.
select Payment_Method,sum(Purchase_Amount) as Revenue,
dense_rank() over(order by sum(Purchase_Amount) desc) as Payment_Method_Dense_Rankings
from shopping_trends
group by Payment_Method
order by Payment_Method_Dense_Rankings;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- S.LAG()
-- 1.Compare each transaction with the previous transaction amount.
select Purchase_Date,Transaction_ID,
lag(Purchase_Amount) over(order by Purchase_Date,Transaction_ID) as Previous_Transaction,
Purchase_Amount as Current_Transaction
from shopping_trends;

-- 2.Compare each customer's purchase amount with their previous purchase.
select Customer_ID,Transaction_ID,
lag(Purchase_Amount) over(partition by Customer_ID order by Purchase_Date,Transaction_ID) as 	Previous_Transaction,
Purchase_Amount as Current_Transaction
from shopping_trends;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- T.LEAD()
-- 1.Show the next purchase amount for every transaction.
select Purchase_Date,Transaction_ID,
Purchase_Amount as Current_Transaction,
lead(Purchase_Amount) over(order by Purchase_Date,Transaction_ID) as Next_Transaction
from shopping_trends;

-- 2.Calculate the difference between current and next purchase
select Customer_ID,Transaction_ID,
Purchase_Amount as Current_Transaction,
lead(Purchase_Amount) over(partition by Customer_ID order by Purchase_Date,Transaction_ID) as Next_Transaction
from shopping_trends;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- U.Running Total
-- 1.Calculate cumulative revenue by purchase date.
with Daily_Revenue as(
	select Purchase_Date as `Date`,sum(Purchase_Amount) as Revenue
    from shopping_trends
    group by Purchase_Date
)

select Date,Revenue as Todays_Total,
sum(Revenue) over(order by Date) as Running_Total
from Daily_Revenue;

-- 2.Calculate cumulative quantity sold.
with Daily_Quantity as(
	select Purchase_Date as `Date`,sum(Quantity) as Units_Sold
    from shopping_trends
    group by Purchase_Date
)

select Date,Units_Sold,
sum(Units_Sold) over(order by Date) as Running_Quantity
from Daily_Quantity;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- V.Moving Average
-- 1.Calculate a 7-day moving average of purchase amount.
with Daily_Revenue as(
	select Purchase_Date as `Date`,round(avg(Purchase_Amount),2) as Revenue
    from shopping_trends
    group by Purchase_Date
)

select Date,Revenue as Todays_Total,
round(avg(Revenue) over(order by Date),2) as Moving_Total
from Daily_Revenue;

-- 2.Calculate a 3 Day rolling average quantity sold.
with Daily_Quantity as(
	select Purchase_Date as `Date`,round(avg(Quantity),2) as Avg_Units_Sold
    from shopping_trends
    group by Purchase_Date
)

select Date,Avg_Units_Sold,
round(avg(Avg_Units_Sold) over(order by Date rows between 2 preceding and current row),2) as Rolling_Quantity
from Daily_Quantity;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- W.NTILE()
-- 1.Divide customers into four spending groups.
with Spending as(
	select Customer_ID,sum(Purchase_Amount) as Spending
    from shopping_trends
    group by Customer_ID
)

select Customer_ID,Spending,
ntile(4) over(order by Spending desc) as Spending_Group
from Spending;

-- 2.Divide products into five revenue buckets.
with Product_Revenue as(
	select Item_Purchased,sum(Purchase_Amount) as Revenue
    from shopping_trends
    group by Item_Purchased
)

select Item_Purchased,Revenue,
ntile(5) over(order by Revenue desc) as Product_Group
from Product_Revenue;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- X.Percent Rank
-- 1.Calculate the purchase amount percentile.
select Customer_ID,Purchase_Amount,
round(Percent_Rank() over(order by Purchase_Amount)*100,2) as Percentile
from shopping_trends
order by Customer_ID;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Y.Window Aggregates
-- 1.Show each customer's spending and overall average spending.
with Customer_Spending as(
	select Customer_ID,round(avg(Purchase_Amount),2) as Average_Spending
    from shopping_trends
    group by Customer_ID
)

select Customer_ID,Average_Spending,
round(avg(Average_Spending) over(),2) as Overall_Average
from Customer_Spending
order by Customer_ID;

-- 2.Show each category's revenue along with overall revenue.
with Category_Revenue as(
	select Category,sum(Purchase_Amount) as Revenue
    from shopping_trends
    group by Category
)

select Category,Revenue,
sum(Revenue) over() as Overall_Revenue
from Category_Revenue;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Z.Advanced CTE
-- 1.Find the Top 3 products in every category.
with Top_3 as(
	select Category,Item_Purchased,sum(Purchase_Amount) as Revenue,
	rank() over(partition by Category order by sum(Purchase_Amount) desc) as Ranking
	from shopping_trends
    group by Item_Purchased,Category
    order by Category
)

select Category,Item_Purchased,Revenue,Ranking
from Top_3
where Ranking <= 3
order by Category,Ranking;

-- 2.Find customers who purchased in multiple months.
select Customer_ID,count(distinct month(Purchase_Date)) as `Count`,
group_concat(distinct monthname(Purchase_Date) order by month(Purchase_Date)) as Months
from shopping_trends
group by Customer_ID
having count(distinct month(Purchase_Date)) > 1
order by Customer_ID,monthname(Purchase_Date);


-- 3.Find repeat customers using CTEs.
with Repeated_Customers as(
	select Customer_ID,count(Transaction_ID) as Repeated_Order
    from shopping_trends
    group by Customer_ID
    having count(Transaction_ID) > 1
)

select Customer_ID,Repeated_Order 
from Repeated_Customers;

-- 4.Find customers whose latest purchase exceeds their previous purchase.
with Latest_Purchase as(
	select Customer_ID,Purchase_Date,Purchase_Amount as Latest_Purchase,
    lag(Purchase_Amount) over(partition by Customer_ID order by Purchase_Date) as Previous_Purchase,
    row_number() over(partition by Customer_ID order by Purchase_Date desc) as Purchase_Rank
    from shopping_trends
)

select Customer_ID,Purchase_Date,Latest_Purchase,Previous_Purchase
from Latest_Purchase
where Purchase_Rank = 1 and Latest_Purchase > Previous_Purchase;

-- 5.Display the longest streak of purchases for each customer (if multiple purchases exist over time).
with Longest_Streak as(
	select Customer_ID,Purchase_Date,
    lead(Purchase_Date) over(partition by Customer_ID order by Purchase_Date) as Next_Purchase_Date,
    row_number() over(partition by Customer_ID order by Purchase_Date) as Purchase_Number
    from shopping_trends
),

Streak as(
	select Customer_ID,Purchase_Date,Next_Purchase_Date,Purchase_Number,date_sub(Purchase_Date,interval Purchase_Number day) as Difference
    from Longest_Streak
),

Streak_Count as(
	select Customer_ID,count(Difference) as Streak
    from Streak
    group by Customer_ID,Difference
)

select Customer_ID,Streak 
from Streak_Count
where Streak > 1;
-- ======================================================================================================================================================================================================================================================
-- Step 5 : Final Business Queries
-- A.KPIs
-- 1.Total Revenue
select sum(Purchase_Amount) as Total_Revenue 
from shopping_trends;

-- 2.Total Orders
select count(Transaction_ID) as Total_Orders
from shopping_trends;

-- 3.Total Customers
select count(distinct Customer_ID) as Total_Customers 
from shopping_trends;

-- 4.Average Order Value
select round(avg(Purchase_Amount),2) as Average_Order_Value
from shopping_trends;

-- 5.Total Quantity Sold
select sum(Quantity) from shopping_trends where Return_Status = 'Not Returned';

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- B.Customer Summary
-- 1.Average Customer Age
select round(avg(Age)) as Average_Age 
from shopping_trends;

-- 2.Top 10 Spending Customers
select Customer_ID,sum(Purchase_Amount) as Top_10_Spending_Customer
from shopping_trends 
group by Customer_ID
order by Top_10_Spending_Customer desc
limit 10;

-- 3.Customer Retention Indicator (based on Previous Purchases)
select Customer_ID,count(Transaction_ID) as Retension
from shopping_trends
group by Customer_ID
having count(Transaction_ID) > 1;
 
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- C.Product Summary
-- 1.Best Selling Category
select Category,sum(Quantity) as Quantity
from shopping_trends
group by Category
order by sum(Quantity) desc
limit 1;

-- 2.Best Selling Item
select Item_Purchased,sum(Quantity) as Quantity
from shopping_trends
group by Item_Purchased
order by sum(Quantity) desc
limit 1;

-- 3.Best Performing Brand
select Brand,sum(Quantity) as Quantity
from shopping_trends
group by Brand
order by sum(Quantity) desc
limit 1;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- D.Sales Summary
-- 1.Highest Single Purchase
select Customer_ID,Purchase_Amount as Highest_Single_Purchase
from shopping_trends
order by Purchase_Amount desc 
limit 1;

-- 2.Lowest Purchase
select Customer_ID,Purchase_Amount as Lowest_Single_Purchase
from shopping_trends
order by Purchase_Amount 
limit 1;

-- 3.Total Discount Given
select sum(
	(Purchase_Amount * Discount) / 100
) as Total_Discount_Given
from shopping_trends;

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- E.Operations Summary
-- 1.Most Popular Payment Method
select Payment_Method,count(Payment_Method) as Number_Of_Times_Used
from shopping_trends
group by Payment_Method
order by count(Payment_Method) desc
limit 1;

-- 2.Most Used Shipping Type
select Delivery_Speed,count(Delivery_Speed) as Number_Of_Times_Used
from shopping_trends
group by Delivery_Speed
order by count(Delivery_Speed) desc
limit 1;

-- 3.Online vs Offline Revenue Contribution
select distinct(select sum(Purchase_Amount) from shopping_trends where Online_Offline = 'Online') as Online_Revenue,
(select sum(Purchase_Amount) from shopping_trends where Online_Offline = 'Offline') as Offline_Revenue
from shopping_trends;

-- 4.Create one final summary table containing:
-- Metric_Value		Total_Revenue	Total_Orders	Total_Customers	Avg_Order_Value		Avg_Customer_Age	Best_Category	
-- Best_Brand	Top_City	Top_Payment_Method	Online_Revenue %	Offline_Revenue %

select 
		distinct(select sum(Purchase_Amount) from shopping_trends) as Total_Revenue,
        (select count(Transaction_ID) from shopping_trends) as Total_Orders,
        (select count(distinct Customer_ID) from shopping_trends) as Total_Customer,
        (select round(avg(Purchase_Amount),2) from shopping_trends) as Average_Order_Value,
        (select round(avg(Age)) from shopping_trends) as Average_Customer_Age,
        (select Category from shopping_trends group by Category order by sum(Quantity) desc limit 1) as Best_Category,
        (select Brand from shopping_trends group by Brand order by sum(Quantity) desc limit 1) as Best_Brand,
        (select Location from shopping_trends group by Location order by sum(Purchase_Amount) desc limit 1) as Top_City,
        (select Payment_Method from shopping_trends group by Payment_Method order by count(Payment_Method) desc limit 1) as Top_Payment_Method,
        round((select (select sum(Purchase_Amount) from shopping_trends where Online_Offline = 'Online') / sum(Purchase_Amount) from shopping_trends)*100,2) as Online_Revenue_Percent,
        round((select (select sum(Purchase_Amount) from shopping_trends where Online_Offline = 'Offline') / sum(Purchase_Amount) from shopping_trends)*100,2) as Offline_Revenue_Percent
from shopping_trends
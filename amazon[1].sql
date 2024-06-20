use capstone

select *
From amazon;

-- SELECT COLUMN_NAME
-- FROM INFORMATION_SCHEMA.COLUMNS
-- WHERE TABLE_SCHEMA = 'capstone' 
-- AND TABLE_NAME = 'amazon';   

Select *
From amazon
where "Invoice ID" or "Branch" or "City"
or "Customer type" or "Gender" or "Product line" or "Unit price"
or "Quantity" or "Tax 5%" or "Total" or "Date" or "Time" or "Payment" or "cogs" or "gross margin"
or "gross income" or "Rating" is null;

-- There are no null values in the dataset

SET SQL_SAFE_UPDATES = 0;
Alter Table amazon
add column timeofday VARCHAR(10);

Update amazon
set timeofday = Case when extract(hour from Time) between 6 and 12 then 'Morning'
				 when extract(hour from Time) between 13 and 17 then 'Afternoon'
                 when extract(hour from Time) between 18 and 23 then 'Evening'
                 else 'Night'
                 End;
                 
Alter table amazon
add column dayname VARCHAR(10);

Update amazon
set dayname = Date_format(Date, '%a');

Alter table amazon
add column monthname VARCHAR(30);

Update amazon
set monthname = date_format(Date, '%b')

-- Exploratory Data Analysis
-- Business Questions To Answer:
-- Question 1:
-- What is the count of distinct cities in the dataset?

Select Count(Distinct City)
From amazon;

-- Answer: There are three Distinct cities in the dataset.

-- Question 2:
-- For each branch, what is the corresponding city?

Select Distinct Branch, City
From amazon
order by branch;

-- Answer: A: Yangon, B: Mandalay, C: Naypyitaw.

-- Question 3:
-- What is the count of distinct product lines in the dataset?

Select Count(Distinct `Product line`)
From amazon;

-- Answer: There are six different product lines in the dataset.

-- Question 4:
-- Which payment method occurs most frequently?

Select max(Payment)
From amazon;

-- Answer: Ewallet is the payment method that has been used more frequently.

-- Question 5:
-- Which product line has the highest sales?

select `product line`, sum(`unit price`) as sales
From amazon
group by `product line`
order by sales desc
Limit 1;

-- Answer: Fashion accessories has highest sales.

-- Question 6:
-- How much revenue is generated each month?

Select monthname as month, Round(sum(Total), 2) as Revenue
from amazon
group by month
order by Revenue desc;

-- Answer: January: 11629.87, Feb: 97219.37, March: 109455.51

-- Question 7:
-- In which month did the cost of goods sold reach its peak?

Select sum(cogs) as Cost_of_Goods_Sold, monthname as month
from amazon
group by month
order by Cost_of_Goods_Sold desc
limit 1;

-- Answer: January

-- Question 8:
-- Which product line generated the highest revenue?

Select `Product line`, ceil(sum(Total)) as Revenue
from amazon
group by `Product line`
order by Revenue desc
Limit 1;

-- Answer: Food and Beverages

-- Question 9:
-- In which city was the highest revenue recorded?

Select City, ceil(sum(Total)) as Revenue
From amazon
Group by city
order by revenue desc
limit 1;

-- Answer: Naypyitaw

-- Question 10:
-- Which product line incurred the highest Value Added Tax?

select `Product line`, round(sum(`Tax 5%`), 2) as VAT
from amazon
group by `Product line`
order by VAT desc
limit 1;

-- Answer: Food and Beverages

-- Question 11:
-- For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."

Select avg(Total) as Average
From amazon;

Select `Product line`, Case When ceil(avg(Total)) > 322 Then 'Good'
							Else 'Bad'
                            End as Rating
From amazon
Group by `Product line`;

-- Question 12:
-- Identify the branch that exceeded the average number of products sold.

Select Branch, sum(Quantity) as volume
From amazon
Group by Branch
Having sum(Quantity) > (Select avg(quantity)
					From amazon)

-- Question 13:
-- Which product line is most frequently associated with each gender?

Select `Product line`, gender, count(*) as Frequency
from amazon
group by `Product line`, gender
order by `Product line`, gender;

-- Answer: Fashion accessories is most frequently associated with Females. Health and Beauty is most frequently associated with males.		

-- Question 14:
-- Calculate the average rating for each product line.

Select `Product line`, round(avg(Rating), 2) as Average_Rating
From amazon
group by `Product line`
order by Average_Rating DESC;

-- Question 15:
-- Count the sales occurrences for each time of day on every weekday.


Select dayname, timeofday, count(Total) as Sales_Occurrences
From amazon
group by dayname, timeofday
order by dayname, timeofday, count(Total) DESC;

-- Answer: On every week day, most number of sales happens in the afternoon period.

-- Question 16:
-- Identify the customer type contributing the highest revenue.

Select `Customer type`, sum(Total) as Revenue
From amazon
group by `Customer type`
order by Revenue desc;

-- Answer: Member has contributed to the most amount of revenue.

-- Question 17:
-- Determine the city with the highest VAT percentage.

Select City, sum(`Tax 5%`) as VAT
from amazon
group by City
order by VAT desc
limit 1;

-- Answer: Naypyitaw has collected highest VAT revenue.

-- Question 18:
-- Identify the customer type with the highest VAT payments.

Select `Customer type`, sum(`Tax 5%`) as VAT
from amazon
group by `Customer type`
order by VAT desc;

-- Answer: Maximum VAT has been collected from Members

-- Question 19:
-- What is the count of distinct customer types in the dataset?

Select count( Distinct `Customer type`) as number_of_customer_types
from amazon;

-- There are two different customer types in the dataset

-- Question 20:
-- What is the count of distinct payment methods in the dataset?

Select count(Distinct Payment) as count_of_payment_methods
From amazon;

-- Answer: There are three different types of payment methods involved.

-- Question 21:
-- Which customer type occurs most frequently?

Select `Customer type`, Count(`Customer type`) as Frequency
From amazon
group by `Customer type`
order by Frequency Desc;

-- Answer: Member has occurred frequently.

-- Question 22:
-- Identify the customer type with the highest purchase frequency.

Select `Customer type`, Count(`Customer type`) as Frequency
From amazon
group by `Customer type`
order by Frequency Desc;

-- Answer: Member has Purchased frequently.

-- Question 23:
-- Determine the predominant gender among customers.

Select gender, count(gender) as Frequency
from amazon
group by gender
order by Frequency Desc;

-- Answer: There are more number of female customers as compared to male customers.

-- Question 24:
-- Examine the distribution of genders within each branch.

Select Branch, Gender, count(gender) as `Distribution of genders`
from amazon
group by Branch, Gender
order by Branch, Gender, count(gender) ASC;

-- Answer: In the branch A and B, Males have more occurrences while in the branch C, Females have more occureneces.

-- Question 25:
-- Identify the time of day when customers provide the most ratings.

Select timeofday, count(Rating) as Rating_counts
from amazon
group by timeofday
order by Rating_counts desc;

-- Answer: The number of ratings are more in the afternoon time.

-- Question 26:
-- Determine the time of day with the highest customer ratings for each branch.

Select Branch, timeofday, max(Rating) as Rating
from amazon
group by Branch, timeofday
order by Branch, timeofday, Rating Desc;

-- Answer: In all the branches, purchases made in the Afternoon has received highest ratings.

-- Question 27:
-- Identify the day of the week with the highest average ratings.

Select dayname, round(avg(Rating), 2) as Avg_Rating
from amazon
group by dayname
order by Avg_Rating desc
Limit 1;

-- Answer: Monday has the highest average rating of 7.15.

-- Question 28:
-- Determine the day of the week with the highest average ratings for each branch.

Select Branch, dayname, Avg_Rating
From (
    Select 
        Branch,
        dayname,
        round(Avg(Rating), 2) AS Avg_Rating,
        Rank() over (Partition by Branch order by Avg(Rating) DESC) AS Rank_
    From 
        amazon
    group by
        Branch, dayname
) as RankedDays
Where Rank_ = 1;

-- Answer: Branch A: Friday, Branch B: Monday, Branch C: Friday.


-- Product Analysis:
-- Conduct analysis on the data to understand the different product lines, the products lines performing best and the product lines that need to be improved.

Select `Product line`, sum(quantity) as Volume_sold
From amazon
group by `Product line`
order by Volume_sold desc;

Select `Product line`, sum(quantity) as Volume_sold
From amazon
group by `Product line`
order by Volume_sold asc
limit 1;

-- Electronic accessories has the most number of sales.
-- Health and beauty has lowest number of sales.

Select Branch, `Product line`, Rank() over (Partition by Branch order by sum(quantity) Desc) as Rank_
From amazon
group by Branch, `Product line`
order by Branch, Rank_ ASC;

-- Branch A has most number of sales in Home and lifestyle category, B has most number of sales in Sports and travel, C in food and Beverages.

Select Gender, `Product line`, count(Total) as Volume_sold
from amazon
group by `Product line`, gender
order by `product line`, gender, Volume_sold desc;

-- Both males and females tend to make purchases equally in all different categories

Select `Product line`, ceil((sum(total) -sum(cogs))) as Profit
from amazon
group by `Product line`
order by Profit Desc;

Select `Product line`, Round(sum(`Tax 5%`), 2) as VAT
from amazon
group by `Product line`
order by VAT Desc;

-- The company has made more profits from Food and beverages and least profits from Health and beauty, same goes with Tax

Select `Product line`, round(avg(Rating), 2) as Avg_Rating
From amazon
group by `Product line`
order by Avg_Rating Desc;

-- Food and beverages has the highest average rating of 7.1 while Home and lifestyle has the lowest average raing of 6.8

Select `Product line`, Round(sum(Total), 2) as Total_Sales
from amazon
group by `Product line`
order by Total_sales Desc;

-- Food and Beverages has made the highest total revenue while Health and beauty contributes to the lowest total revenue

Select `Product line`, max(`unit price`)
from amazon
group by `Product line`;

Select `Product line`, min(`unit price`)
from amazon
group by `Product line`;

-- All the segments have similar maximum and minimum prices.

-- Sales Analysis:
-- This analysis aims to answer the question of the sales trends of product. The result of this can help us measure the effectiveness of each sales strategy the business applies and what modifications are needed to gain more sales.

Select Date, Floor(sum(Total)) as Revenue
from amazon
group by Date
order by Revenue Desc;

-- Maximum Revenue is generated on 9th march.
-- Lowest Revenue is generated on February 13th.

Select monthname as Month, Round(sum(total), 2) as Revenue, ceil((sum(total) -sum(cogs))) as Profit
from amazon
group by month
order by Revenue Desc;

-- January is the most profitable month and February is the least profitable.

Select Branch, Round(sum(total), 2) as Total_sales
from amazon
group by branch
order by Total_sales Desc;

-- Branch C has the highest sales and B has the lowest sales

Select Branch, Round(avg(total),2) as Avg_sales
from amazon
Group by Branch;

-- Branch A has Average sales of 312.35, Branch B has 319.87, C has 337.1

Select Case When dayname in ('mon', 'tue', 'wed', 'thu', 'fri') Then 'Weekday'
			Else 'Weekend'
            End AS dayofweek, ceil(sum(Total)) as Total_sales
From amazon
Group by dayofweek
Order by Total_sales Desc;

-- Maximum purchases have occurred on weekdays.

select `customer type`, sum(Total) as Total_sales
From amazon
group by `customer type`
order by Total_sales Desc;

select `customer type`, count(Total) as No_of_purchases
From amazon
group by `customer type`
order by No_of_purchases Desc;

-- Members has contributed to highest revenue
-- Both members and normal customers have made similar number of purchases.

-- Customer Analysis
-- This analysis aims to uncover the different customer segments, purchase trends and the profitability of each customer segment.

Select `Customer type`, count(Distinct `Invoice ID`) as Number_of_Transactions, round(sum(total), 2) as total_revenue, round(avg(total), 2) as Avg_revenue
From amazon
Group by (`Customer type`)
order by total_revenue Desc;

-- Members has contributed to highest total revenue and total average revenue
-- Both members and normal customers have made similar number of purchases.

Select `Customer type`, floor((sum(total) - sum(cogs))) as Profit
From amazon
Group by `Customer type`
order by Profit Desc;

-- Members has contributed to most profits than non members.

Select Gender, Count(Total), sum(Total) as Total_sales, avg(total) as average_per_transaction
from amazon
Group by gender
order by Total_sales Desc;

-- Females lead in number of transactions, total revenue and average sale per transaction.

SELECT `Customer type`, 
       AVG(rating) AS average_rating
FROM amazon
GROUP BY `Customer type`;

-- Both members and non members have given similar ratings for their purchases. The average rating for purchases is 7.0

Select `Customer type`, Case When dayname in ('mon', 'tue', 'wed', 'thu', 'fri') Then 'Weekday'
			Else 'Weekend'
            End AS dayofweek, count(Total) as Number_of_Transactions
From amazon
group by `Customer type`, dayofweek
order by Number_of_Transactions Desc;

-- Both members and non members have made most number of purchases on weekdays.

With X as (Select `Customer type`, `Product line`, count(Total) as number_of_purchases, Rank() over (partition by `Product line` order by count(Total) desc) as Ranking
from amazon
group by `Customer type`, `Product line`
order by  `Product line`) Select *
						  From X
                          Where Ranking = 1;

-- Members have purchased more products on Food and beverages, Home and lifesyle and on sports and travel products when compared to non members.

            



    



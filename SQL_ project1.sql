 --- SQL Retail Sales Analysis - P1 --
 create sql_project_p2;

drop table if exists retail_sales;
 create table retail_sales
			 (
				 transactions_id INT PRIMARY KEY,
				 sale_date DATE,	
				 sale_time TIME,
				 customer_id INT,
				 gender VARCHAR(15),
				 age INT,
				 category VARCHAR(15),
				 quantity INT,
				 price_per_unit FLOAT,	
				 cogs FLOAT,
				 total_sale FLOAT
				 );



select * from retail_sales
where transactions_id is null


select count(*) from retail_sales



select * from retail_sales
where
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantity is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;


delete from retail_sales
where
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantity is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;



--- Data Exploration 

-- how many sales we have?

select count(*) as total_sales from retail_sales;


select count(distinct customer_id) as total_sales from retail_sales;

--- Data analysis & business key problem

-- Q1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * from retail_sales
where sale_date = '2022-11-05'

--Q2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select * from retail_sales
where 
category = 'Clothing'
and
quantity >= 4
and
TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

--Write a SQL query to calculate the total sales (total_sale) for each category.

select category,
sum(total_sale) as net_sale
from
retail_sales
group by category
order by net_sale desc;

--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category

select category,
round(avg(age), 2) as Average_age
from retail_sales
where category = 'Beauty'
group by category

--Write a SQL query to find all transactions where the total_sale is greater than 1000

select * from retail_sales
where total_sale > 1000

select gender,
category,
count(transactions_id) as Number_of_transaction
from retail_sales
group by gender, category;

--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select * from
(
	select
		extract(year from sale_date) as year,
		extract(month from sale_date) as month,
		avg(total_sale) as avg_sale,
		rank() over(partition by extract(year from sale_date)order by avg(total_sale) desc)
	from retail_sales
	group by 1,2
	order by 3 desc
)
as t1
where rank = 1

--Write a SQL query to find the top 5 customers based on the highest total sales

select customer_id,
sum(total_sale) as Amount
from retail_sales
group by 1
order by 2
limit 5;

--Write a SQL query to find the number of unique customers who purchased items from each category

select category,
count(distinct customer_id) as count_of_unique_customer
from retail_sales
group by category

--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
select *, 
case
	when extract(hour from sale_time) <12 then 'Morning'
	when extract(hour from sale_time)  between 12 and 17 then 'Afternoon'
	else 'Evening'
	end as shift
from retail_sales
)

WITH hourly_sale AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)

select shift,
	count(*) as total_order
	from hourly_sale
	group by shift


-- end of project
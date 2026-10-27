-- Sales Data Analysis Project --

-- Create Database
IF NOT EXISTS (SELECT name FROM SYS.databases WHERE name = 'sql_project_p1')
BEGIN
	CREATE DATABASE sql_project_p1
END;

-- Use Database
USE sql_project_p1
GO;

-- Create Table
DROP TABLE IF EXISTS retail_sales

CREATE TABLE retail_sales(
		transactions_id	INT PRIMARY KEY,
		sale_date	DATE,
		sale_time	TIME,
		customer_id	VARCHAR(256),
		gender	VARCHAR(10),
		age	INT,
		category	VARCHAR(256),	
		quantiy	INT,
		price_per_unit	MONEY,
		cogs	INT,
		total_sale MONEY
);

SELECT COUNT(*) FROM retail_sales


SELECT * FROM [dbo].[retail_sales]

SELECT * FROM [dbo].[retail_sales]
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	total_sale IS NULL


-- Delete null Record
DELETE retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	total_sale IS NULL;


-- DATA Exploration

-- How many sales we have
SELECT COUNT(*) FROM retail_sales

-- How many CUSTOMER we have
SELECT COUNT(DISTINCT(customer_id)) FROM retail_sales

--How many total number of category availabe
SELECT COUNT(DISTINCT(category)) FROM retail_sales

SELECT DISTINCT(category) FROM retail_sales


-- Data Analysis and key problems

--Q1: Write a sql query to retrieve all columns for sales made on '2022-11-05'
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05'


--Q2: Write a sql query to retrieve all transactions where the categories is 'clothing' and the quatity 
-- sold is more the 10 in the month of November 2022

SELECT * 
FROM retail_sales
WHERE category = 'clothing'
	AND
	FORMAT(sale_date,'yyyy-MM') = '2022-11'
	AND
	quantiy >= 4;

--Q3: Write the sql query to calculate total sales (total sales) for each categories.

SELECT 
	category,
	SUM(total_sale) AS net_sales,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY
	category;


--Q4: Write a sql query to find the average age of customer who purchase items from the 'beuty' category

SELECT 
	ROUND(AVG(age),2) AS avg_age
FROM retail_sales
WHERE category = 'beauty'


--Q5: Write a sql to find all transactions where the total_sales is greater than 1000.

SELECT
	* 
FROM retail_sales
WHERE total_sale > 1000;


--Q6: Write a sql query to find the total number of transactions (transactions_id) made by each gender each category

SELECT
	gender,
	category,
	COUNT(*) AS total_number_trx
FROM retail_sales
GROUP BY
	gender,
	category
ORDER BY
	category ASC;

--Q7: Write a sql query to calculate the avg sales for each month. find out best selleing month of each year.

SELECT 
	TOP 1
	FORMAT(sale_date,'yyyy-MM') AS month,
	FORMAT(sale_date,'yyyy') AS year,
	AVG(total_sale) AS avg_sales
FROM retail_sales
GROUP BY
	FORMAT(sale_date,'yyyy-MM'),
	FORMAT(sale_date,'yyyy')
ORDER BY 
	avg_sales DESC;


SELECT 
	TOP 1
	MONTH(sale_date) AS month,
	YEAR(sale_date) AS year,
	AVG(total_sale) AS avg_sales
FROM retail_sales
GROUP BY
	MONTH(sale_date),
	YEAR(sale_date)
ORDER BY 
	avg_sales DESC;

SELECT * FROM (
	SELECT
		MONTH(sale_date) AS month,
		YEAR(sale_date) AS year,
		AVG(total_sale) AS avg_sales,
		RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rank
	FROM retail_sales
	GROUP BY
		MONTH(sale_date),
		YEAR(sale_date)
) AS t1
WHERE rank = 1;

-- Using CTE

WITH t2 AS (
SELECT
	MONTH(sale_date) AS month,
	YEAR(sale_date) AS year,
	AVG(total_sale) AS avg_sales,
	RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY
	MONTH(sale_date),
	YEAR(sale_date)
)
SELECT * FROM t2 WHERE rank = 1;


--Q8: Write a sql query to find the top 5 customers based the highest total sales

SELECT
	TOP 5
	customer_id,
	SUM(total_sale) AS sales
	
FROM 
	retail_sales
GROUP BY
	customer_id
ORDER BY
	SUM(total_sale) DESC;

-- Using CTE rank()
WITH t2 AS(
	SELECT
		customer_id,
		SUM(total_sale) AS sales,
		RANK() OVER (ORDER BY SUM(total_sale) DESC) AS sales_rank
	FROM 
		retail_sales
	GROUP BY
		customer_id
)
SELECT * FROM t2
WHERE sales_rank <= 5
ORDER BY sales_rank;


--Q9: Write sql query to find the number of unique customer who purchased items from each category.

SELECT
	category,
	COUNT(DISTINCT customer_id) AS distinct_cust
FROM retail_sales
GROUP BY
	category;

--Q10: Write a sql query to each shift and number of orders (Example morning <=12, Afternoon between 12 & 17, evening > 17)

SELECT FORMAT(sale_time, 'hh') FROM retail_sales


WITH shift AS (
	SELECT 
		*,
		CASE
			WHEN DATEPART(hh,sale_time) < 12 THEN 'morning'
			WHEN DATEPART(hh,sale_time) BETWEEN 12 AND  17 THEN 'after noon'
			ELSE 'evening'
		END AS shift
	FROM retail_sales
)
SELECT 
	shift,
	COUNT(customer_id) AS number_of_order
FROM shift
GROUP  BY
	shift;


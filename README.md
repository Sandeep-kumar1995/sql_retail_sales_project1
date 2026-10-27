# 📊 Retail Sales Data Analysis Using SQL

## 📌 Project Overview

This project analyzes retail sales data using **Microsoft SQL Server** to identify sales trends, customer purchasing behavior, product category performance, and transaction patterns.

The project covers data cleaning, exploratory data analysis (EDA), and business problem-solving using SQL queries to extract meaningful insights from retail sales data.

## 🎯 Project Objectives

- Clean and prepare retail sales data for analysis.
- Explore sales transactions, customers, and product categories.
- Calculate total sales and transaction counts by category.
- Analyze customer demographics and purchasing behavior.
- Identify the best-performing month of each year.
- Find the top 5 customers based on total sales.
- Analyze transactions by time of day.

## 🛠️ Tools & Technologies

- **Database:** Microsoft SQL Server
- **Query Language:** SQL (T-SQL)
- **IDE:** SQL Server Management Studio (SSMS)

## 📂 Dataset Description

The dataset contains retail transaction details, including customer information, product categories, sales amounts, and transaction dates.

| Column | Description |
| --- | --- |
| `transactions_id` | Unique transaction identifier |
| `sale_date` | Date of the sale |
| `sale_time` | Time of the sale |
| `customer_id` | Customer identifier |
| `gender` | Customer gender |
| `age` | Customer age |
| `category` | Product category |
| `quantiy` | Quantity of products sold |
| `price_per_unit` | Price per unit |
| `cogs` | Cost of goods sold |
| `total_sale` | Total transaction sales amount |

## 🧹 Data Cleaning

The data-cleaning process identifies and removes records containing missing values in important columns, including transaction ID, date, time, customer ID, gender, category, quantity, and total sales.

sql


SELECT *
FROM retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantiy IS NULL
   OR total_sale IS NULL;


After reviewing the missing records, incomplete rows can be removed to improve data quality.

## 🔍 Exploratory Data Analysis (EDA)

The initial analysis answers the following questions:

- How many sales transactions are in the dataset?
- How many unique customers are present?
- How many distinct product categories are available?
- What product categories are represented?

## 📈 Business Questions Answered

### Q1. Retrieve all sales made on November 5, 2022

sql


SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';


### Q2. Find clothing transactions with quantities greater than 10 in November 2022

sql


SELECT *
FROM retail_sales
WHERE category = 'clothing'
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01'
  AND quantiy > 10;


### Q3. Calculate total sales and transaction counts for each category

sql


SELECT
    category,
    SUM(total_sale) AS net_sales,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category
ORDER BY net_sales DESC;


### Q4. Find the average age of customers purchasing beauty products

sql


SELECT
    ROUND(AVG(CAST(age AS DECIMAL(10, 2))), 2)
        AS avg_age
FROM retail_sales
WHERE category = 'beauty';


### Q5. Retrieve transactions with total sales greater than 1,000

sql


SELECT *
FROM retail_sales
WHERE total_sale > 1000;


### Q6. Count transactions by gender and product category

sql


SELECT
    gender,
    category,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY gender, category
ORDER BY category;


### Q7. Identify the best-performing sales month for each year

sql


WITH MonthlySales AS (
    SELECT
        YEAR(sale_date) AS sales_year,
        MONTH(sale_date) AS sales_month,
        AVG(CAST(total_sale AS DECIMAL(18, 2)))
            AS avg_sales
    FROM retail_sales
    GROUP BY
        YEAR(sale_date),
        MONTH(sale_date)
),
RankedMonths AS (
    SELECT *,
        RANK() OVER (
            PARTITION BY sales_year
            ORDER BY avg_sales DESC
        ) AS sales_rank
    FROM MonthlySales
)
SELECT
    sales_year,
    sales_month,
    avg_sales
FROM RankedMonths
WHERE sales_rank = 1
ORDER BY sales_year;


### Q8. Find the top 5 customers based on total sales

sql


SELECT TOP 5
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC;


### Q9. Find the number of unique customers in each category

sql


SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category
ORDER BY unique_customers DESC;


### Q10. Analyze the number of orders by time of day

The transactions are divided into three shifts:

- **Morning:** Before 12 PM
- **Afternoon:** 12 PM to 5:59 PM
- **Evening:** 6 PM onward

sql


WITH ShiftAnalysis AS (
    SELECT
        transactions_id,
        CASE
            WHEN DATEPART(HOUR, sale_time) < 12
                THEN 'Morning'
            WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17
                THEN 'Afternoon'
            ELSE 'Evening'
        END AS sales_shift
    FROM retail_sales
)
SELECT
    sales_shift,
    COUNT(*) AS number_of_orders
FROM ShiftAnalysis
GROUP BY sales_shift
ORDER BY
    CASE sales_shift
        WHEN 'Morning' THEN 1
        WHEN 'Afternoon' THEN 2
        WHEN 'Evening' THEN 3
    END;


## 🧠 SQL Concepts Used

- Database and table creation
- Data cleaning and handling NULL values
- Filtering with `WHERE`
- Aggregations using `SUM()`, `AVG()`, and `COUNT()`
- Grouping with `GROUP BY`
- Sorting with `ORDER BY`
- Date and time functions
- Conditional statements using `CASE`
- Common Table Expressions (CTEs)
- Window functions using `RANK()`
- Customer and sales analysis

## 📊 Expected Business Insights

This project helps identify:

- Best-performing product categories by sales revenue.
- High-value customers and their contribution to sales.
- Monthly sales performance across different years.
- Customer purchasing patterns by gender and age.
- Popular shopping periods throughout the day.
- Categories with the highest number of unique customers.

_Actual results and business findings should be documented after executing the queries against the dataset._

## 📁 Project Structure

text


sql-retail-sales-analysis/
│
├── README.md
├── retail_sales_analysis.sql
└── retail_sales.csv

## 🚀 How to Run the Project

1. Install Microsoft SQL Server and SQL Server Management Studio (SSMS).
2. Download the retail sales dataset.
3. Create the database and `retail_sales` table using the SQL script.
4. Import the dataset into the table.
5. Execute the data-cleaning queries.
6. Run the exploratory analysis and business queries.
7. Review the results to identify sales trends and customer insights.

**Important:** The original SQL script drops and recreates the `retail_sales` table. Run that section carefully because it deletes the existing table and its data.

## 🔮 Future Improvements

- Create interactive dashboards using Power BI or Tableau.
- Analyze year-over-year sales growth.
- Calculate profit margins by product category.
- Optimize query performance with appropriate indexes.
- Add visualizations and screenshots of query results.
- Implement additional data-quality checks.

## 👨‍💻 Author

**Sandeep Kushwaha**

Aspiring Data Analyst | SQL | Data Analytics

- GitHub: https://github.com/Sandeep-kumar1995/
- LinkedIn: https://www.linkedin.com/in/sandeep-kushwaha-0b99931a3/
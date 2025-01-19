## Project Report: Retail Online Sales Analysis

-- DATABASE INFORMATION

-- This is a transactional data set which contains all the transactions occurring between 01/12/2010 and 09/12/2011 for a UK-based and registered non-store online retail.
-- The company mainly sells unique all-occasion gifts. Many customers of the company are wholesalers.



-- 1. Introduction
-- This project analyzes the retail sales data from the RETAIL_ONLINE table within the RETAIL database. The primary aim of this project is to extract valuable business insights that can inform decision-making in sales strategy, inventory management, and customer engagement. The analysis includes a comprehensive range of topics, from identifying missing data to calculating total sales per transaction, best-selling products, customer behavior, sales trends over time, and more.

-- By conducting this analysis, we aim to:

-- Cleanse and preprocess the data
-- Identify key sales patterns
-- Evaluate product and customer performance
-- Calculate relevant KPIs to understand business performance

-- 2. Data Preparation and Quality Check
-- Before diving into the analysis, we first checked and cleaned the data.

-- Missing Data Check
-- Objective: Identify rows with missing data for critical fields (QUANTITY, UNIT_PRICE, CUSTOMER_ID).
-- Query:

USE RETAIL;

SELECT * FROM retail_online 
WHERE 
QUANTITY IS NULL OR
UNIT_PRICE IS NULL OR
CUSTOMER_ID IS NULL;

-- Insight: If missing values were identified, corrective actions such as data imputation or removal of rows with critical missing information would have been taken.


SELECT * FROM RETAIL_ONLINE;
 

-- Update InvoiceDate to be in 'YYYY-MM-DD' format

UPDATE RETAIL_ONLINE
SET Invoice_Date = STR_TO_DATE(Invoice_Date, '%d-%m-%Y')
WHERE STR_TO_DATE(Invoice_Date, '%d-%m-%Y') IS NOT NULL;

-- Insight: The conversion ensured that date-based analysis, such as monthly or weekly sales trends, could be done accurately.

-- Identify Total Sales per Transaction

SELECT 
    INVOICE_NO, SUM(QUANTITY * UNIT_PRICE) AS TOTAL_AMOUNT
FROM
    retail_online
GROUP BY INVOICE_NO;

-- Insight: The total sales per transaction helps to understand the average transaction value, and it can be used to assess customer spending behavior.



-- Identify the Best-Selling Products

SELECT 
    STOCK_CODE, SUM(QUANTITY)
FROM
    retail_online
GROUP BY STOCK_CODE
ORDER BY STOCK_CODE DESC;

-- Insight: This query provides insight into which products are most popular and help prioritize inventory restocking, marketing efforts, and product placement.



-- Identify Revenue by Product

SELECT 
    STOCK_CODE, SUM(QUANTITY * UNIT_PRICE) AS REVENUE
FROM
    retail_online
GROUP BY STOCK_CODE
ORDER BY REVENUE DESC;

-- Insight: This analysis identifies the revenue-generating products, helping to optimize the product portfolio and manage high-margin products effectively.



-- Identify the Most Frequent Customers

SELECT 
    CUSTOMER_ID, COUNT(INVOICE_NO) AS TOTAL_INVOICES
FROM
    retail_online
GROUP BY CUSTOMER_ID 
ORDER BY TOTAL_INVOICES DESC;

-- Insight: The most frequent customers represent the company's loyal customer base. These customers should be targeted for personalized promotions and retention strategies.



-- Sales Analysis by Country

SELECT 
    COUNTRY, SUM(QUANTITY * UNIT_PRICE) AS SALES
FROM
    retail_online
GROUP BY COUNTRY
ORDER BY SALES DESC;


-- Insight: This query provides insights into the most profitable regions, helping businesses to focus their marketing efforts and product distribution in the most lucrative markets.




-- Analyze Sales Trends Over Time

SELECT 
    MONTH(INVOICE_DATE) AS MONTH,
    CASE 
        WHEN MONTH(INVOICE_DATE) = 1 THEN 'January'
        WHEN MONTH(INVOICE_DATE) = 2 THEN 'February'
        WHEN MONTH(INVOICE_DATE) = 3 THEN 'March'
        WHEN MONTH(INVOICE_DATE) = 4 THEN 'April'
        WHEN MONTH(INVOICE_DATE) = 5 THEN 'May'
        WHEN MONTH(INVOICE_DATE) = 6 THEN 'June'
        WHEN MONTH(INVOICE_DATE) = 7 THEN 'July'
        WHEN MONTH(INVOICE_DATE) = 8 THEN 'August'
        WHEN MONTH(INVOICE_DATE) = 9 THEN 'September'
        WHEN MONTH(INVOICE_DATE) = 10 THEN 'October'
        WHEN MONTH(INVOICE_DATE) = 11 THEN 'November'
        WHEN MONTH(INVOICE_DATE) = 12 THEN 'December'
        ELSE 'Invalid Month'
    END AS MONTH_NAME,
    SUM(QUANTITY * UNIT_PRICE) AS TOTAL_SALES
FROM RETAIL_ONLINE
GROUP BY MONTH, MONTH_NAME
ORDER BY MONTH;


-- Insight: Monthly sales trends help in understanding seasonality, identifying peak sales periods, and adjusting inventory and marketing strategies accordingly.



-- Sales Conversion Rate 


SELECT 
    SUM(QUANTITY * UNIT_PRICE) / COUNT(DISTINCT INVOICE_NO) AS AVG_SALE_TRANS
FROM
    RETAIL_ONLINE;
    
-- Insight: The average sales per transaction helps in evaluating the effectiveness of sales strategies and can highlight opportunities for upselling and cross-selling.

    
-- Most expensive products sold

SELECT 
    STOCK_CODE,
    DESCRIPTION,
    UNIT_PRICE,
    SUM(QUANTITY * UNIT_PRICE) AS TOTAL_SALES
FROM
    RETAIL_ONLINE
GROUP BY STOCK_CODE , DESCRIPTION, UNIT_PRICE
ORDER BY UNIT_PRICE DESC;


-- Insight: This analysis identifies high-value products that might be targeted for premium marketing, special offers, or customer loyalty programs.



--  Sales by time of day

SELECT 
    HOUR(INVOICE_TIME) AS SALE_HOUR,
    SUM(QUANTITY * UNIT_PRICE) AS TOTAL_SALES
FROM
    RETAIL_ONLINE
GROUP BY SALE_HOUR
ORDER BY SALE_HOUR;


-- Insight: Identifying peak sales hours allows businesses to optimize staffing, marketing campaigns, and promotional efforts during high-traffic hours.



-- Average sale per invoice

SELECT 
    AVG(TOTAL_SALES)
FROM
    (SELECT 
        INVOICE_NO, SUM(QUANTITY * UNIT_PRICE) AS TOTAL_SALES
    FROM
        RETAIL_ONLINE
    GROUP BY INVOICE_NO) AS TOTAL_INVOICE_SALES;
    

-- Insight: The average sale per invoice provides insights into customer purchasing behavior and helps evaluate overall business performance.




--  Sales trend by day of week

SELECT 
    DAYOFWEEK(INVOICE_DATE) AS DAY_OF_WEEK,
    CASE
        WHEN DAYOFWEEK(INVOICE_DATE) = 1 THEN 'SUNDAY'
        WHEN DAYOFWEEK(INVOICE_DATE) = 2 THEN 'MONDAY'
        WHEN DAYOFWEEK(INVOICE_DATE) = 3 THEN 'TUESDAY'
        WHEN DAYOFWEEK(INVOICE_DATE) = 4 THEN 'WEDNESDAY'
        WHEN DAYOFWEEK(INVOICE_DATE) = 5 THEN 'THURSDAY'
        WHEN DAYOFWEEK(INVOICE_DATE) = 6 THEN 'FRIDAY'
        WHEN DAYOFWEEK(INVOICE_DATE) = 7 THEN 'SATURDAY'
        ELSE 'INVALID DAY'
    END AS DAY_NAME,
    SUM(QUANTITY * UNIT_PRICE) AS TOTAL_SALES
FROM RETAIL_ONLINE
GROUP BY DAYOFWEEK(INVOICE_DATE), DAY_NAME
ORDER BY TOTAL_SALES DESC;


-- Insight: This analysis helps identify which days of the week generate the most revenue and allows businesses to plan promotions, offers, and marketing strategies accordingly.




--  Find out how many products have never been sold

SELECT 
    STOCK_CODE, DESCRIPTION
FROM
    RETAIL_ONLINE
GROUP BY STOCK_CODE , DESCRIPTION
HAVING SUM(QUANTITY) = 0;


-- Insight: Identifying unsold products helps businesses optimize inventory, discontinue underperforming products, or reassess marketing strategies.




-- Find invoices with total value above a certain threshold (Eg: 1000)


SELECT 
    INVOICE_NO, SUM(QUANTITY * UNIT_PRICE)
FROM
    RETAIL_ONLINE
GROUP BY INVOICE_NO
HAVING SUM(QUANTITY * UNIT_PRICE) >= 1000;


-- Insight: High-value invoices highlight major revenue-generating transactions. These can be analyzed for patterns, such as specific products or customers, that contribute significantly to total sales.



-- . Conclusion
-- The project successfully provided valuable insights into the sales data of the retail store. Through data cleansing, trend analysis, and KPI calculation, the following key takeaways were identified:

-- Best-selling and most profitable products
-- Customer purchasing behavior and loyalty patterns
-- Geographical performance and market-specific sales trends
-- Seasonal and time-based trends that impact sales performance


-- These insights can be used by the business to enhance marketing strategies, optimize inventory, 
-- and increase customer engagement. 
-- Further analysis can be conducted to implement targeted promotions or optimize product pricing based on customer purchasing patterns.


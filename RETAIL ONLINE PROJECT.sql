# Retail Online Sales Analysis Project

## Overview

This project aims to analyze retail sales data from a UK-based non-store online retail business. The company specializes in selling unique all-occasion gifts, and many of its customers are wholesalers. The analysis focuses on transactional data from **01/12/2010** to **09/12/2011** stored in the **RETAIL_ONLINE** table within the **RETAIL** database. 

The project is designed to extract actionable business insights to help optimize sales strategies, inventory management, and customer engagement. The analysis covers key metrics like sales trends, customer behavior, and product performance. 

## Objectives
1. Cleanse and preprocess the data to ensure its accuracy.
2. Identify key sales patterns and trends.
3. Evaluate product and customer performance.
4. Calculate relevant Key Performance Indicators (KPIs) for better business decision-making.

---

## Data Preparation and Quality Check

Before diving into the analysis, it's important to first check and clean the data. Here's how we performed data validation and preprocessing:

### 1. Missing Data Check

We began by checking for missing critical fields (QUANTITY, UNIT_PRICE, CUSTOMER_ID) and took corrective actions if needed.

```sql
USE RETAIL;

SELECT * FROM retail_online 
WHERE 
QUANTITY IS NULL OR
UNIT_PRICE IS NULL OR
CUSTOMER_ID IS NULL;
```

If any missing values were found, the next step would involve either imputing the missing data or removing the rows with critical missing information.

---

### 2. Date Format Standardization

Next, we ensured that the `Invoice_Date` column was in the correct format (`YYYY-MM-DD`) for accurate time-based analysis.

```sql
UPDATE RETAIL_ONLINE
SET Invoice_Date = STR_TO_DATE(Invoice_Date, '%d-%m-%Y')
WHERE STR_TO_DATE(Invoice_Date, '%d-%m-%Y') IS NOT NULL;
```

---

## Core Analysis

Now that the data is ready, let's dive into the key business analysis queries that will help us extract valuable insights:

### 1. Total Sales Per Transaction

To understand the average transaction value and customer spending, we calculate the total sales per invoice.

```sql
SELECT 
    INVOICE_NO, SUM(QUANTITY * UNIT_PRICE) AS TOTAL_AMOUNT
FROM
    retail_online
GROUP BY INVOICE_NO;
```

---

### 2. Best-Selling Products

Identifying the most popular products can help prioritize inventory restocking and marketing efforts.

```sql
SELECT 
    STOCK_CODE, SUM(QUANTITY)
FROM
    retail_online
GROUP BY STOCK_CODE
ORDER BY STOCK_CODE DESC;
```

---

### 3. Revenue by Product

We can further evaluate which products are generating the most revenue by calculating their total sales value.

```sql
SELECT 
    STOCK_CODE, SUM(QUANTITY * UNIT_PRICE) AS REVENUE
FROM
    retail_online
GROUP BY STOCK_CODE
ORDER BY REVENUE DESC;
```

---

### 4. Most Frequent Customers

To analyze customer loyalty and engagement, we identify the customers who have placed the most orders.

```sql
SELECT 
    CUSTOMER_ID, COUNT(INVOICE_NO) AS TOTAL_INVOICES
FROM
    retail_online
GROUP BY CUSTOMER_ID 
ORDER BY TOTAL_INVOICES DESC;
```

---

### 5. Sales by Country

Understanding regional sales helps focus marketing efforts in the most profitable markets.

```sql
SELECT 
    COUNTRY, SUM(QUANTITY * UNIT_PRICE) AS SALES
FROM
    retail_online
GROUP BY COUNTRY
ORDER BY SALES DESC;
```

---

### 6. Sales Trends Over Time

To understand seasonal variations and sales trends, we group sales by month and year.

```sql
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
```

---

### 7. Sales Conversion Rate

To assess the effectiveness of sales strategies, we calculate the average sales per transaction.

```sql
SELECT 
    SUM(QUANTITY * UNIT_PRICE) / COUNT(DISTINCT INVOICE_NO) AS AVG_SALE_TRANS
FROM
    RETAIL_ONLINE;
```

---

### 8. Most Expensive Products Sold

Identifying high-value products can help target premium marketing efforts.

```sql
SELECT 
    STOCK_CODE,
    DESCRIPTION,
    UNIT_PRICE,
    SUM(QUANTITY * UNIT_PRICE) AS TOTAL_SALES
FROM
    RETAIL_ONLINE
GROUP BY STOCK_CODE , DESCRIPTION, UNIT_PRICE
ORDER BY UNIT_PRICE DESC;
```

---

### 9. Sales by Time of Day

This helps businesses understand peak hours and optimize staffing and marketing campaigns.

```sql
SELECT 
    HOUR(INVOICE_TIME) AS SALE_HOUR,
    SUM(QUANTITY * UNIT_PRICE) AS TOTAL_SALES
FROM
    RETAIL_ONLINE
GROUP BY SALE_HOUR
ORDER BY SALE_HOUR;
```

---

### 10. Average Sale Per Invoice

To get a better sense of overall purchasing behavior, we calculate the average sale value per invoice.

```sql
SELECT 
    AVG(TOTAL_SALES)
FROM
    (SELECT 
        INVOICE_NO, SUM(QUANTITY * UNIT_PRICE) AS TOTAL_SALES
    FROM
        RETAIL_ONLINE
    GROUP BY INVOICE_NO) AS TOTAL_INVOICE_SALES;
```

---

### 11. Sales Trend by Day of Week

To further refine marketing efforts, we analyze sales performance based on the day of the week.

```sql
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
```

---

### 12. Products That Have Never Been Sold

This helps businesses optimize inventory by identifying underperforming products.

```sql
SELECT 
    STOCK_CODE, DESCRIPTION
FROM
    RETAIL_ONLINE
GROUP BY STOCK_CODE , DESCRIPTION
HAVING SUM(QUANTITY) = 0;
```

---

### 13. High-Value Invoices

We also identify invoices that exceed a certain threshold (e.g., $1000) to focus on high-revenue transactions.

```sql
SELECT 
    INVOICE_NO, SUM(QUANTITY * UNIT_PRICE)
FROM
    RETAIL_ONLINE
GROUP BY INVOICE_NO
HAVING SUM(QUANTITY * UNIT_PRICE) >= 1000;
```

---

## Conclusion

The analysis provides several valuable insights into the retail business, including:

- **Best-Selling Products**: Insights into which products are popular and profitable.
- **Customer Behavior**: Understanding purchasing patterns and customer loyalty.
- **Sales Trends**: Identifying peak sales times (monthly, weekly, and daily).
- **Revenue Optimization**: Targeting high-value products and transactions for better revenue.

With this information, the business can make data-driven decisions to optimize inventory, tailor marketing campaigns, and enhance customer engagement Strategies

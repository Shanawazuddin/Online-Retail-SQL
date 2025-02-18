# Retail Online Sales Analysis 📊

Welcome to the **Retail Online Sales Analysis** project! This repository demonstrates how SQL can transform raw transactional data into actionable business insights for a UK-based online retailer specializing in unique all-occasion gifts. By analyzing sales patterns, customer behavior, and product performance, this project provides valuable takeaways for sales strategy, inventory management, and customer engagement.

---

## 🌟 Project Overview

The dataset includes transactional data from **01/12/2010 to 09/12/2011** and contains key fields like:

- **INVOICE_NO**: Unique transaction ID  
- **CUSTOMER_ID**: Customer identifier  
- **QUANTITY**: Items sold in each transaction  
- **UNIT_PRICE**: Price per unit of the item  
- **INVOICE_DATE**: Date of the transaction  
- **COUNTRY**: Customer's location

This project answers critical business questions such as:
- **Which products drive the most revenue?**
- **Who are the most loyal customers?**
- **What are the seasonal trends in sales?**
- **Which countries contribute the most to sales?**

---

## 🔑 Key Features

1. **Data Preprocessing**:
   - Handled missing or null values in critical fields.
   - Standardized the `INVOICE_DATE` format for consistent analysis.

2. **Sales Insights**:
   - Calculated total sales per transaction.
   - Identified best-selling products and their revenue contributions.
   - Analyzed sales trends by month, day of the week, and time of day.

3. **Customer Analysis**:
   - Identified high-frequency, high-value customers.
   - Examined customer loyalty patterns.

4. **Regional & Seasonal Trends**:
   - Analyzed sales by country and region.
   - Uncovered seasonal sales trends to plan for peak times.

5. **Product Optimization**:
   - Identified unsold products for inventory management.
   - Analyzed revenue performance of premium products.

---

## 🚀 Installation and Setup

### 1. **Clone the repository**:
   ```bash
   git clone https://github.com/shanawazuddin/retail-online-sales-analysis.git
   cd retail-online-sales-analysis
   ```

### 2. **Set up the database**:
   - Import the `RETAIL_ONLINE` table schema into your database.

### 3. **Run the SQL Queries**:
   - Use your SQL environment (MySQL, PostgreSQL, etc.) to execute queries located in the `queries.sql` file.

### 4. **Explore the Insights**:
   - Analyze the results to uncover key trends and make data-driven decisions.

---

## 📂 SQL Queries and Analysis

Below are the key SQL queries that analyze the retail sales data and generate actionable insights for the business.

### 1. **Data Preprocessing and Cleaning**

**Check for missing critical data**:

```sql
USE RETAIL;

SELECT * FROM retail_online 
WHERE 
    QUANTITY IS NULL OR
    UNIT_PRICE IS NULL OR
    CUSTOMER_ID IS NULL;
```

**Standardize date format**:

```sql
UPDATE RETAIL_ONLINE
SET Invoice_Date = STR_TO_DATE(Invoice_Date, '%d-%m-%Y')
WHERE STR_TO_DATE(Invoice_Date, '%d-%m-%Y') IS NOT NULL;
```

---

### 2. **Core Analysis Queries**

**Total sales per transaction**:

```sql
SELECT 
    INVOICE_NO, SUM(QUANTITY * UNIT_PRICE) AS TOTAL_AMOUNT
FROM
    retail_online
GROUP BY INVOICE_NO;
```

**Best-selling products (by quantity sold)**:

```sql
SELECT 
    STOCK_CODE, SUM(QUANTITY) AS TOTAL_SOLD
FROM
    retail_online
GROUP BY STOCK_CODE
ORDER BY TOTAL_SOLD DESC;
```

**Revenue by product**:

```sql
SELECT 
    STOCK_CODE, SUM(QUANTITY * UNIT_PRICE) AS REVENUE
FROM
    retail_online
GROUP BY STOCK_CODE
ORDER BY REVENUE DESC;
```

**Most frequent customers**:

```sql
SELECT 
    CUSTOMER_ID, COUNT(INVOICE_NO) AS TOTAL_ORDERS
FROM
    retail_online
GROUP BY CUSTOMER_ID 
ORDER BY TOTAL_ORDERS DESC;
```

**Sales by country**:

```sql
SELECT 
    COUNTRY, SUM(QUANTITY * UNIT_PRICE) AS TOTAL_SALES
FROM
    retail_online
GROUP BY COUNTRY
ORDER BY TOTAL_SALES DESC;
```

**Sales trends over time**:

- **Monthly sales trends**:

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

- **Sales by day of the week**:

```sql
SELECT 
    DAYOFWEEK(INVOICE_DATE) AS DAY, 
    SUM(QUANTITY * UNIT_PRICE) AS TOTAL_SALES
FROM 
    retail_online
GROUP BY DAY
ORDER BY TOTAL_SALES DESC;
```

---

### 3. **Advanced Business Insights**

**Most expensive products sold**:

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

**High-value transactions**:

```sql
SELECT 
    INVOICE_NO, SUM(QUANTITY * UNIT_PRICE)
FROM
    RETAIL_ONLINE
GROUP BY INVOICE_NO
HAVING SUM(QUANTITY * UNIT_PRICE) >= 1000;
```

**Products that have never been sold**:

```sql
SELECT 
    STOCK_CODE, DESCRIPTION
FROM
    RETAIL_ONLINE
GROUP BY STOCK_CODE , DESCRIPTION
HAVING SUM(QUANTITY) = 0;
```

**Sales conversion rate**:

```sql
SELECT 
    SUM(QUANTITY * UNIT_PRICE) / COUNT(DISTINCT INVOICE_NO) AS AVG_SALE_TRANS
FROM
    RETAIL_ONLINE;
```

---

## 📈 Key Insights

1. **Top Products**: Identified the best-sellers and high-revenue products.
2. **Loyal Customers**: Recognized the most frequent buyers for targeted promotions.
3. **Seasonality**: Found that sales peak during specific months and days of the week.
4. **Inventory Optimization**: Highlighted unsold products to discontinue or re-promote.
5. **Regional Insights**: Most sales originated from the UK, with significant contributions from other regions.

---

## ✨ Future Scope

- **Advanced Analytics**: Perform customer clustering and segmentation based on purchasing behavior.
- **Predictive Analysis**: Implement sales forecasting using machine learning models.
- **Dashboard Integration**: Integrate with BI tools like Power BI or Tableau for enhanced visualization and reporting.

---

## 🤝 Contributing

Feel free to fork this repository, submit issues, or contribute improvements to this project. Contributions are welcome!

---

## 📬 Contact

Have questions or feedback? Reach out via [LinkedIn](https://www.linkedin.com/in/shanawaz474/) or [Email](mailto:shanawazuddin474@gmail.com). 

# Retail Online Sales Analysis 📊

Welcome to the **Retail Online Sales Analysis** project! This repository showcases how SQL can transform raw transactional data into actionable business insights for a UK-based online retailer specializing in unique all-occasion gifts. By analyzing sales patterns, customer behavior, and product performance, this project provides valuable takeaways for sales strategy, inventory management, and customer engagement.

---

## 🌟 Project Overview

The dataset contains transactional data from **01/12/2010 to 09/12/2011** and includes the following key fields:

- **INVOICE_NO**: Unique transaction ID  
- **CUSTOMER_ID**: Customer identifier  
- **QUANTITY**: Items sold in each transaction  
- **UNIT_PRICE**: Price per unit of the item  
- **INVOICE_DATE**: Date of the transaction  
- **COUNTRY**: Country of the customer  

This analysis answers critical business questions like:  
- **Which products drive the most revenue?**  
- **Who are the most loyal customers?**  
- **What are the seasonal trends in sales?**  
- **Which countries contribute the most to sales?**

---

## 🔑 Key Features

1. **Data Preprocessing**:  
   - Checked and cleaned data for missing or null values in critical fields.  
   - Standardized `INVOICE_DATE` format to `YYYY-MM-DD`.  

2. **Sales Insights**:  
   - Total sales per transaction.  
   - Best-selling products and their revenue contributions.  
   - Sales trends by month, day of the week, and time of day.  

3. **Customer Analysis**:  
   - Identified frequent and high-value customers.  
   - Examined customer loyalty patterns.  

4. **Performance Trends**:  
   - Sales by region and country.  
   - Seasonal and time-based trends for strategic planning.  

5. **Product Optimization**:  
   - Unsold products for inventory adjustments.  
   - Revenue and performance of premium products.

---

## 🚀 Installation and Setup

1. **Clone this repository**:
   ```bash
   git clone https://github.com/shanawazuddin/retail-online-sales-analysis.git
   cd retail-online-sales-analysis
   ```

2. **Set up the database**:
   - Import the `RETAIL_ONLINE` table schema or a similar dataset.

3. **Run the SQL queries**:
   - Use your preferred SQL environment (e.g., MySQL, PostgreSQL) to execute the queries in the `queries.sql` file.

4. **Explore insights**:
   - Analyze the output to uncover trends and actionable insights.

---

## 📂 SQL Analysis and Queries  

### **1. Data Preprocessing and Cleaning**  
Standardize the date format and check for missing data in critical fields.  
```sql
-- Check for missing data
SELECT * FROM retail_online 
WHERE QUANTITY IS NULL OR UNIT_PRICE IS NULL OR CUSTOMER_ID IS NULL;

-- Update date format
UPDATE RETAIL_ONLINE
SET INVOICE_DATE = STR_TO_DATE(INVOICE_DATE, '%d-%m-%Y')
WHERE STR_TO_DATE(INVOICE_DATE, '%d-%m-%Y') IS NOT NULL;
```

### **2. Total Sales per Transaction**  
Calculate the total value of each transaction.  
```sql
SELECT 
    INVOICE_NO, SUM(QUANTITY * UNIT_PRICE) AS TOTAL_AMOUNT
FROM
    retail_online
GROUP BY INVOICE_NO;
```

### **3. Best-Selling Products**  
Identify the most popular products based on quantity sold.  
```sql
SELECT 
    STOCK_CODE, SUM(QUANTITY) AS TOTAL_SOLD
FROM
    retail_online
GROUP BY STOCK_CODE
ORDER BY TOTAL_SOLD DESC;
```

### **4. Revenue by Product**  
Analyze which products generate the most revenue.  
```sql
SELECT 
    STOCK_CODE, SUM(QUANTITY * UNIT_PRICE) AS REVENUE
FROM
    retail_online
GROUP BY STOCK_CODE
ORDER BY REVENUE DESC;
```

### **5. Most Frequent Customers**  
Identify loyal customers based on transaction frequency.  
```sql
SELECT 
    CUSTOMER_ID, COUNT(INVOICE_NO) AS TOTAL_ORDERS
FROM
    retail_online
GROUP BY CUSTOMER_ID 
ORDER BY TOTAL_ORDERS DESC;
```

### **6. Sales by Country**  
Discover the most profitable regions.  
```sql
SELECT 
    COUNTRY, SUM(QUANTITY * UNIT_PRICE) AS TOTAL_SALES
FROM
    retail_online
GROUP BY COUNTRY
ORDER BY TOTAL_SALES DESC;
```

### **7. Sales Trends Over Time**  
Analyze sales by month, day of the week, and time of day.  
```sql
-- Monthly sales trends
SELECT 
    MONTH(INVOICE_DATE) AS MONTH, 
    SUM(QUANTITY * UNIT_PRICE) AS TOTAL_SALES
FROM 
    retail_online
GROUP BY MONTH
ORDER BY MONTH;

-- Sales by day of the week
SELECT 
    DAYOFWEEK(INVOICE_DATE) AS DAY, 
    SUM(QUANTITY * UNIT_PRICE) AS TOTAL_SALES
FROM 
    retail_online
GROUP BY DAY
ORDER BY TOTAL_SALES DESC;

-- Sales by hour of the day
SELECT 
    HOUR(INVOICE_TIME) AS HOUR, 
    SUM(QUANTITY * UNIT_PRICE) AS TOTAL_SALES
FROM 
    retail_online
GROUP BY HOUR
ORDER BY HOUR;
```

### **8. High-Value Transactions**  
Identify invoices exceeding a specific threshold (e.g., 1000).  
```sql
SELECT 
    INVOICE_NO, SUM(QUANTITY * UNIT_PRICE) AS TOTAL_AMOUNT
FROM
    retail_online
GROUP BY INVOICE_NO
HAVING TOTAL_AMOUNT >= 1000;
```

### **9. Unsold Products**  
Find products that have never been sold.  
```sql
SELECT 
    STOCK_CODE, DESCRIPTION
FROM
    retail_online
GROUP BY STOCK_CODE, DESCRIPTION
HAVING SUM(QUANTITY) = 0;
```

---

## 📈 Key Insights  

1. **Top Products**: Identified the best-sellers and high-revenue items.  
2. **Loyal Customers**: Recognized frequent buyers for targeted promotions.  
3. **Seasonality**: Sales peaked in specific months and days of the week.  
4. **Unsold Inventory**: Highlighted items to discontinue or re-promote.  
5. **Regional Insights**: Most sales originated from the UK, followed by other regions.  

---

## ✨ Future Scope

- Advanced analytics like clustering customers by purchase behavior.  
- Predictive analysis for sales forecasting.  
- Integration with dashboards (e.g., Power BI, Tableau) for visualization.  

---

## 🤝 Contributing

Feel free to fork the repository, raise issues, or contribute enhancements!

---

## 📬 Contact  

If you have any questions or feedback, connect with me on [LinkedIn](https://www.linkedin.com/in/shanawazuddin) or [email](shanawazuddin474@gmail.com)


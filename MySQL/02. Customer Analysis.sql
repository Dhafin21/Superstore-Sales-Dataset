-- --------------------------------------------
-- CUSTOMER ANALYSIS
-- --------------------------------------------


-- --------------------------------------------
-- Customer Overview
-- --------------------------------------------
-- 1. Jumlah Customer
SELECT COUNT(DISTINCT(`Customer ID`)) AS Total_Customer
FROM customers;

-- ---------------------------------------------
-- 2. Rata - Rata Sales per Customer
SELECT
	SUM(Sales) /  COUNT(DISTINCT(`Customer ID`)) AS Rata_Customer
FROM sales;

-- ----------------------------------------------
-- 3. TOP 10 Customer berdasarkan total sales
SELECT 
	c.`Customer Name`,
    ROUND(SUM(s.Sales),2) AS Total_Sales,
    RANK() OVER(ORDER BY ROUND(SUM(s.Sales),2)DESC) AS RANKING
FROM sales s
INNER JOIN customers c
	ON s.`Customer ID` = c.`Customer ID`
GROUP BY c.`Customer Name`
ORDER BY Total_Sales DESC
LIMIT 10;

-- ----------------------------------------------
-- 4. BOTTOM 10 Customer berdasarkan total Sales
SELECT 
	c.`Customer Name`,
    ROUND(SUM(s.Sales),2) AS Total_Sales,
    RANK() OVER(ORDER BY ROUND(SUM(s.Sales),2)ASC) AS RANKING
FROM sales s
INNER JOIN customers c
	ON s.`Customer ID` = c.`Customer ID`
GROUP BY c.`Customer Name`
ORDER BY Total_Sales
LIMIT 10;

-- ----------------------------------------------
-- 5. Kontribusi TOP 10 Customer
WITH Total_Sales_Customer AS (
SELECT 
	c.`Customer Name`,
    ROUND(SUM(s.Sales),2) AS Total_Sales
FROM sales s
INNER JOIN customers c
	ON s.`Customer ID` = c.`Customer ID`
GROUP BY c.`Customer Name` 
ORDER BY Total_Sales DESC
LIMIT 10 )

SELECT
    ROUND((SELECT SUM(Total_Sales) 
    FROM Total_Sales_Customer) /
    (SELECT SUM(Sales) 
    FROM sales) *100,2) AS kontribusi_top10;
    
-- ----------------------------------------------
-- 6. Customer yang paling sering melakukan Order
SELECT 
	c.`Customer Name`,
    COUNT(DISTINCT(s.`Order ID`)) AS Total_Order
FROM sales s
INNER JOIN customers c
	ON s.`Customer ID` = c.`Customer ID`
GROUP BY c.`Customer Name`
ORDER BY Total_Order DESC;

-- ----------------------------------------------
-- 7. Customer dengan rata - rata order tertinggi
WITH sumcst AS (
SELECT 
	c.`Customer Name`,
    COUNT(DISTINCT(s.`Order ID`)) AS Orders,
	ROUND(SUM(s.Sales),2) AS Total
FROM sales s
INNER JOIN customers c
	ON s.`Customer ID` = c.`Customer ID`
GROUP BY c.`Customer Name`)

SELECT 
	`Customer Name`,
    Orders,
    Total,
    ROUND(Total / Orders,2) AS Rata
FROM sumcst
ORDER BY Rata DESC
LIMIT 1;

-- ----------------------------------------------
-- 8. Customer yang membeli kategori produk paling banyak
SELECT 
	c.`Customer Name`,
    COUNT(DISTINCT(p.`Category`)) AS Total_Product_Category
FROM sales s
INNER JOIN customers c
	ON s.`Customer ID` = c.`Customer ID`
INNER JOIN product p
	ON s.`Product ID` = p.`Product ID`
GROUP BY c.`Customer Name`
ORDER BY Total_Product_Category DESC;

-- ----------------------------------------------
-- 9. Ranking Customer berdasarkan Total Sales
SELECT
	c.`Customer Name`,
    ROUND(SUM(s.Sales),2) AS Total_Sales,
    RANK() OVER(ORDER BY ROUND(SUM(s.Sales),2)DESC) AS RANKING
FROM sales s
INNER JOIN customers c
	ON s.`Customer ID` = c.`Customer ID`
GROUP BY c.`Customer Name`
ORDER BY Total_Sales DESC;

-- ----------------------------------------------
-- 10. Ranking Customer berdasarkan Jumlah Order
SELECT
	c.`Customer Name`,
    COUNT(DISTINCT(s.`Order ID`)) AS Jumlah_Order,
    RANK() OVER(ORDER BY COUNT(DISTINCT(s.`Order ID`))DESC) AS RANKING
FROM sales s
INNER JOIN customers c
	ON s.`Customer ID` = c.`Customer ID`
GROUP BY c.`Customer Name`
ORDER BY Jumlah_Order DESC;

-- ----------------------------------------------
-- 11. Customer Level
WITH sum_cust AS (
SELECT
	c.`Customer Name`,
    ROUND(SUM(s.Sales),2) AS Total_Sales
FROM sales s
INNER JOIN customers c
	ON s.`Customer ID` = c.`Customer ID`
GROUP BY c.`Customer Name`
ORDER BY Total_Sales DESC)

SELECT 
	`Customer Name`,
    Total_Sales,
    CASE
		WHEN Total_Sales >= 3000 THEN 'VIP'
		WHEN Total_Sales >= 400 THEN 'REGULAR'
		ELSE 'LOW VALUE'
    END AS Customer_Level
FROM sum_cust;

-- NOTED no. 11
-- Customer Level ditentukan berdasarkan threshold
-- yang dibuat untuk simulasi segmentasi customer.
-- Pada project nyata sebaiknya threshold ditentukan
-- berdasarkan distribusi data customer perusahaan.


-- ===========================================
-- Sales Overview
-- ===========================================

-- -------------------------------------------
-- Overall Performance
-- -------------------------------------------
-- 1. Total Sales
 SELECT SUM(Sales) AS Total_Sales
 FROM sales;
 
-- -------------------------------------------
-- 2. Total Order
SELECT COUNT(DISTINCT(`Order ID`)) AS Total_Order
FROM sales;

-- --------------------------------------------
-- 3. Rata Rata Sales per Transaksi
SELECT ROUND(SUM(Sales) / COUNT(DISTINCT(`Order ID`)),2) AS Rata_Transaksi
FROM sales;

-- ---------------------------------------------
-- 4. Transaksi Terbesar
SELECT 
	c.`Customer Name`,
    s.`Customer ID`,
    SUM(s.Sales) AS Total_Sales
FROM sales s
INNER JOIN customers c
 ON s.`Customer ID` = c.`Customer ID`
GROUP BY c.`Customer Name`, s.`Customer ID` 
ORDER BY Total_Sales DESC
LIMIT 1;

-- ---------------------------------------------
-- 5. Transaksi Terkecil
SELECT 
	c.`Customer Name`,
    s.`Customer ID`,
    SUM(s.Sales) AS Total_Sales
FROM sales s
INNER JOIN customers c
 ON s.`Customer ID` = c.`Customer ID`
GROUP BY c.`Customer Name`, s.`Customer ID` 
ORDER BY Total_Sales
LIMIT 1;

-- -------------------------------------------
-- Sales By Kategori
-- -------------------------------------------
-- 6. Total Sales berdasarkan kategori
SELECT
	p.Category,
    SUM(s.Sales) AS Sales_Kategori
FROM sales s
INNER JOIN product p
	ON s.`Product ID` = p.`Product ID`
GROUP BY p.Category;

-- -------------------------------------------
-- 7. Persentase Kontribusi setiap kategori berdasarkan Total Sales
WITH sum_kategori AS (
SELECT
	p.Category,
    SUM(s.Sales) AS Sales_Kategori
FROM sales s
INNER JOIN product p
	ON s.`Product ID` = p.`Product ID`
GROUP BY p.Category
)
SELECT Category,
	Sales_Kategori,
    ROUND(Sales_Kategori / 
    ( SELECT 
    SUM(Sales_Kategori)
    FROM sum_kategori) * 100,2) AS Kontribusi
FROM sum_kategori;

-- -------------------------------------------
-- 8. Kategori Sales Terbesar
WITH sum_kategori AS (
SELECT
	p.Category,
    SUM(s.Sales) AS Sales_Kategori
FROM sales s
INNER JOIN product p
	ON s.`Product ID` = p.`Product ID`
GROUP BY p.Category
)
SELECT *
FROM sum_kategori
ORDER BY Sales_Kategori DESC
LIMIT 1;

-- -------------------------------------------
-- Sales By Region
-- -------------------------------------------
-- 9. Total Sales berdasarkan region
SELECT 
	Region,
    SUM(Sales) AS Sales_Region
FROM Sales
GROUP BY Region;

-- -------------------------------------------
-- 10. Region dengan sales terbesar
WITH sum_region AS (
SELECT 
	Region,
    SUM(Sales) AS Sales_Region
FROM Sales
GROUP BY Region
)
SELECT *
FROM sum_region
GROUP BY Region
ORDER BY Sales_Region DESC
LIMIT 1;

-- -------------------------------------------
-- 11. Region dengan rata rata sales tertinggi
SELECT 
	Region,
    AVG(Sales) AS Rata_Region
FROM Sales
GROUP BY Region;

-- -------------------------------------------
-- Monthly Sales
-- -------------------------------------------
-- 12. Total Sales setiap Bulan
SELECT
	MONTH(o.Order_Date_New) AS Nomor,
    MONTHNAME(o.Order_Date_New) AS Bulan,
    ROUND(SUM(s.Sales),2) AS Sales_Bulan
FROM sales s
INNER JOIN orders o
	ON s.`Order ID` = o.`Order ID`
GROUP BY Nomor, Bulan
ORDER BY nomor;

-- -------------------------------------------
-- 12. Bulan dengan Sales Terbesar
WITH sales_bulan AS 
(
SELECT 
	MONTH(o.Order_Date_New) AS Nomor,
    MONTHNAME(o.Order_Date_New) AS Bulan,
    ROUND(SUM(s.Sales),2) AS Sales_Bulan
FROM sales s
INNER JOIN orders o
	ON s.`Order ID` = o.`Order ID`
GROUP BY Nomor, Bulan
)
SELECT *
FROM sales_bulan
ORDER BY Sales_Bulan DESC
LIMIT 1;

-- -------------------------------------------
-- 13. Running Total Sales Perbulan
WITH sales_bulan AS 
(
SELECT 
	MONTH(o.Order_Date_New) AS Nomor,
    MONTHNAME(o.Order_Date_New) AS Bulan,
    ROUND(SUM(s.Sales),2) AS Sales_Bulan
FROM sales s
INNER JOIN orders o
	ON s.`Order ID` = o.`Order ID`
GROUP BY Nomor, Bulan
)
SELECT 
    Nomor,
    Bulan,
    Sales_Bulan,
    ROUND(SUM(Sales_Bulan) OVER (ORDER BY Nomor),2) AS Running_Totoal
FROM sales_bulan;
-- Get total sales by year
SELECT Year, SUM(Global_Sales) AS Total_Sales
FROM videogame_sales
GROUP BY Year 
ORDER BY Year;

-- Sales each year for a specific platform
SELECT Year, SUM(Global_Sales) as Total_Global_Sales
FROM videogame_sales
Where platform = 'PS2'
GROUP BY Year, Platform
ORDER BY Year;

-- Total sales by region
SELECT 'North America' AS Region, SUM(NA_Sales) AS Sales
FROM videogame_sales
UNION ALL
SELECT 'Europe' AS Region, SUM(EU_Sales) AS Sales
FROM videogame_sales
UNION ALL
SELECT 'Japan' AS Region, SUM(JP_Sales) AS Sales
FROM videogame_sales
UNION ALL
SELECT 'Other' AS Region, SUM(Other_Sales) AS Sales
FROM videogame_sales;

--  Identify the most popular genres in different regions by comparing the total sales and average sales per game
SELECT Genre,
       SUM(NA_Sales) AS Total_NA_Sales,
       AVG(NA_Sales) AS Avg_NA_Sales,
       SUM(EU_Sales) AS Total_EU_Sales,
       AVG(EU_Sales) AS Avg_EU_Sales,
       SUM(JP_Sales) AS Total_JP_Sales,
       AVG(JP_Sales) AS Avg_JP_Sales,
       SUM(Other_Sales) AS Total_Other_Sales,
       AVG(Other_Sales) AS Avg_Other_Sales,
       SUM(Global_Sales) AS Total_Global_Sales,
       AVG(Global_Sales) AS Avg_Global_Sales
FROM videogame_sales
GROUP BY Genre;

-- Identifying the top-selling platforms and their best-performing genres.
SELECT Platform,
		Genre,
		SUM(Global_Sales) AS Total_Sales, 
		AVG(Global_Sales) AS Average_Sales
FROM videogame_sales
GROUP BY Platform, Genre
ORDER BY Total_Sales DESC;

-- Find the distribution of sales across different years for a specific genre
SELECT 
  year, 
  SUM(NA_Sales) AS total_NA_sales, 
  SUM(EU_Sales) AS total_EU_sales, 
  SUM(JP_Sales) AS total_JP_sales, 
  SUM(Other_Sales) AS total_other_sales, 
  SUM(Global_Sales) AS total_global_sales
FROM videogame_sales
WHERE genre = 'Shooter'
GROUP BY year
ORDER BY year;


-- Analyze the performance of video games across different platforms
SELECT vs1.name, 
	vs1.platform,
	vs1.NA_Sales, 
	vs1.EU_Sales, 
	vs1.JP_Sales, 
	vs1.Other_Sales,
    vs1.global_sales
FROM videogame_sales vs1
JOIN (
    SELECT name
    FROM videogame_sales
    GROUP BY name
    HAVING COUNT(*) > 1
) vs2 ON vs1.name = vs2.name
ORDER BY vs1.name, vs1.platform;

-- Get the top 3 selling games for all platforms
SELECT v.platform, v.name, v.global_sales
FROM (
  SELECT platform, name, global_sales,
    ROW_NUMBER() OVER (PARTITION BY platform ORDER BY global_sales DESC) AS rn
  FROM videogame_sales
) AS v
WHERE v.rn <= 3
ORDER BY v.platform, v.global_sales DESC;


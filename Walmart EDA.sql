
-- General overview of the data 

SELECT * 
FROM [WalmartSalesData.csv]

------------------------------------------------------------------------------------------------------
------Feature Engineering-------

--Making a time of day column
SELECT 
	Time,
	CASE
		WHEN Time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
		WHEN Time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
		ELSE 'Evening'
	END AS TimeCategory

FROM [WalmartSalesData.csv]
ORDER BY Time

--Adding the new column to the database
ALTER TABLE [WalmartSalesData.csv] ADD time_category VARCHAR(20)

--Adding data to the new column
UPDATE [WalmartSalesData.csv]
SET time_category = CASE
						WHEN Time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
						WHEN Time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
						ELSE 'Evening'
					END

--Creating day of the week column
SELECT 
	Date,
	FORMAT(Date, 'dddd') AS day_name

FROM [WalmartSalesData.csv]

--Adding a new column to the database
ALTER TABLE [WalmartSalesData.csv] ADD day_name VARCHAR(20)

--Adding data to new column
UPDATE [WalmartSalesData.csv]
SET day_name = FORMAT(Date, 'dddd') 

--Creating Month name column
SELECT
	Date,
	FORMAT(Date, 'MMMM') AS month_name

FROM [WalmartSalesData.csv]
ORDER BY 1 desc

--Creating a Month name table in the database
ALTER TABLE [WalmartSalesData.csv] ADD month_name VARCHAR(20)

--Adding data to the table
UPDATE [WalmartSalesData.csv]
SET month_name = FORMAT(Date,'MMMM')



----------------------------------------------------------------------------------------------------------------------

----------EDA Questions-------------
--What are the diffeent cities  in the database?
SELECT
	DISTINCT(City)	
FROM [WalmartSalesData.csv]

--In which city is each individual branch?
SELECT 
	DISTINCT City,
	Branch
FROM [WalmartSalesData.csv]
ORDER BY 2 

--What are the different product lines?
SELECT
	DISTINCT Product_line
FROM [WalmartSalesData.csv]

--What is the most common payment method?
SELECT TOP 1
	Payment,
	COUNT(Payment) AS number_of_times
FROM [WalmartSalesData.csv]
GROUP BY Payment
ORDER BY 2 DESC

--What product line sells the most?
SELECT 
	Product_line,
	SUM(Quantity) as Quantity
FROM [WalmartSalesData.csv]
GROUP BY Product_line
ORDER BY 2 DESC

--What is the total revenue per month?
SELECT
	month_name,
	SUM(Unit_price * Quantity) AS revenue
FROM [WalmartSalesData.csv]
GROUP BY month_name
ORDER BY 2 DESC


--What month had the largest cost of goods sold (cogs)?
SELECT TOP 1
	month_name,
	SUM(cogs * Quantity) as TotalCogs
FROM [WalmartSalesData.csv]
GROUP BY month_name
ORDER BY 2 DESC



--What product line has the largest revenue?
SELECT TOP 1
	Product_line,
	SUM(Unit_price * Quantity) AS Revenue
FROM [WalmartSalesData.csv]
GROUP BY Product_line
ORDER BY 2 DESC


--Which is the city with the largest revenue?
SELECT TOP 1
	City,
	SUM(Unit_price * Quantity) AS Revenue
FROM [WalmartSalesData.csv]
GROUP BY City
ORDER BY 2 DESC



--What product line has the largest vat?
SELECT 
	Product_line,
	MAX(Vat) AS MaxVat
FROM [WalmartSalesData.csv]
GROUP BY Product_line
ORDER BY 2 DESC

--Which branch sold more products than average?
WITH BranchProductQuantities AS(
	SELECT
		Branch,
		SUM(Quantity) AS TotalQuantitiesSold
	FROM [WalmartSalesData.csv]
	GROUP BY Branch
)

SELECT
	Branch,
	TotalQuantitiesSold
FROM BranchProductQuantities
WHERE TotalQuantitiesSold > (SELECT AVG(TotalQuantitiesSold) FROM BranchProductQuantities)

--What is the most common product line by gender?
SELECT 
	Gender,
	Product_line,
	COUNT(Product_line) AS Quantity	
FROM [WalmartSalesData.csv]
GROUP BY Gender, Product_line
ORDER BY 1,3 DESC

--What is the average rating by product line?
SELECT
	Product_line,
	ROUND(AVG(Rating),2) as AverageRating
FROM [WalmartSalesData.csv]
GROUP BY Product_line
ORDER BY 2 DESC

--Number of sales made by day and time of day
SELECT
	day_name,
	time_category AS TimeOfDay,
	COUNT(*) AS NumberOfSales
FROM [WalmartSalesData.csv]
GROUP BY day_name, time_category
ORDER BY CASE day_name
        WHEN 'Monday' THEN 1
        WHEN 'Tuesday' THEN 2
        WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4
        WHEN 'Friday' THEN 5
        WHEN 'Saturday' THEN 6
        WHEN 'Sunday' THEN 7
    END,
	CASE time_category
		WHEN 'Morning' THEN 1
		WHEN 'Afternoon' THEN 2
		WHEN 'Evening' THEN 3
	END

--Which customer type brings in the most revenue?
SELECT TOP 1
	Customer_type,
	SUM(Quantity * Unit_price) AS Revenue
FROM [WalmartSalesData.csv]
GROUP BY Customer_type
ORDER BY 2 DESC

--Which city has the largest tax percent?
SELECT TOP 1
	City,
	MAX(Vat) AS HighestVAT
FROM [WalmartSalesData.csv]
GROUP BY City
ORDER BY 2 DESC

--Which customer type pays the most in VAT?
SELECT TOP 1
	Customer_type,
	MAX(Vat) AS HighestVAT
FROM [WalmartSalesData.csv]
GROUP BY Customer_type
ORDER BY 2 DESC

--How many customer Types are in the dataset
SELECT DISTINCT(Customer_type)
FROM [WalmartSalesData.csv]

--What is the most common customer type?
SELECT TOP 1
	Customer_type,
	COUNT(*) AS CustomerTypeCount
FROM [WalmartSalesData.csv]
GROUP BY Customer_type
ORDER BY 2 DESC

--What customer type buys the most?
SELECT TOP 1
	Customer_type,
	SUM(Quantity) AS QuantityBought
FROM [WalmartSalesData.csv]
GROUP BY Customer_type
ORDER BY 2 DESC

--What is the gender distribution of customers?
SELECT 
	Gender,
	COUNT(*) AS GenderCount
FROM [WalmartSalesData.csv]
GROUP BY Gender
ORDER BY 2 DESC

----What is the gender distribution per branch?
SELECT 
	Branch,
	Gender,	
	COUNT(*) AS GenderCount
FROM [WalmartSalesData.csv]
GROUP BY Branch, Gender
ORDER BY Branch, Gender

--At what time of day do customers give the highest ratings?
SELECT TOP 1
	time_category AS TimeOfDay,
	AVG(Rating) AS AvgRating
FROM [WalmartSalesData.csv]
GROUP BY time_category
ORDER BY 2 DESC

--At what time of day do customers give the highest ratings per branch?
SELECT TOP 3
	Branch,
	time_category AS TimeOfDay,
	AVG(Rating) AS AvgRating
FROM [WalmartSalesData.csv]
GROUP BY Branch, time_category
ORDER BY 2 DESC

-- Which day of the week has the best average rating
SELECT TOP 1
	day_name,
	AVG(Rating) AS AvgRating
FROM [WalmartSalesData.csv]
GROUP BY day_name
ORDER BY 2 DESC

--Which day of the week has the best average rating per branch?
WITH RankedDays AS (
	SELECT
		Branch,
		day_name,
		AVG(Rating) AS AvgRating,
		ROW_NUMBER() OVER (PARTITION BY Branch ORDER BY AVG(Rating) DESC) AS Ranking
	FROM [WalmartSalesData.csv]
	GROUP BY Branch, day_name
)
SELECT 
	Branch,
	day_name,
	AvgRating
FROM RankedDays
WHERE Ranking = 1


-- What is the average transaction value per payment method?
SELECT
    Payment AS Payment_Method,
    AVG(Total) AS Average_Transaction_Value
FROM
    [WalmartSalesData.csv]
GROUP BY Payment
ORDER BY 2 DESC;






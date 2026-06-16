				             --SQL ANALYSIS--
							 

SELECT * FROM "Blinkit Sales"
LIMIT 5;

--What’s total sales we made?--
SELECT SUM("Total Sales") AS Total_Sales
FROM "Blinkit Sales";

--Which item type sells most?--
SELECT "Item Type", SUM("Total Sales") AS Type_Sales
FROM "Blinkit Sales"
GROUP BY "Item Type"
ORDER BY Type_Sales DESC
LIMIT 5;

--Which outlet size gives highest avg sales?--
SELECT "Outlet Size", AVG("Total Sales") AS Avg_Sales
FROM "Blinkit Sales"
GROUP BY "Outlet Size"
ORDER BY Avg_Sales DESC;

--How many unique items we have?--
SELECT COUNT(DISTINCT "Item Identifier") AS Total_Products
FROM "Blinkit Sales";


--Items selling above category avg?--
SELECT "Item Identifier", "Item Type", "Total Sales"
FROM "Blinkit Sales" b1
WHERE "Total Sales" > (
    SELECT AVG("Total Sales")
    FROM "Blinkit Sales" b2
    WHERE b2."Item Type" = b1."Item Type"
)
ORDER BY "Total Sales" DESC
LIMIT 5;


--Find outlet types with avg sales > overall avg?--
SELECT "Outlet Type",
       ROUND(AVG("Total Sales")::numeric, 2) AS Avg_Sales_Per_Outlet
FROM "Blinkit Sales"
GROUP BY "Outlet Type"
HAVING AVG("Total Sales") > (
    SELECT AVG("Total Sales") FROM "Blinkit Sales"
)
ORDER BY Avg_Sales_Per_Outlet DESC;


--Worst performing item in each item type?--
SELECT "Item Type", "Item Identifier", "Total Sales"
FROM "Blinkit Sales" b1
WHERE "Total Sales" = (
    SELECT MIN("Total Sales")
    FROM "Blinkit Sales" b2
    WHERE b2."Item Type" = b1."Item Type"
)
ORDER BY "Item Type";

--Outlets with inconsistent sales?--
WITH Outlet_Stats AS (
    SELECT "Outlet Identifier",
           COUNT(*) AS Num_Items,
           STDDEV("Total Sales") AS Sales_Variability
    FROM "Blinkit Sales"
    GROUP BY "Outlet Identifier"
)
SELECT * FROM Outlet_Stats
WHERE Sales_Variability > 500
  AND Num_Items > 20
ORDER BY Sales_Variability DESC


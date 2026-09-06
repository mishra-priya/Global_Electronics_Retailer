---1. What is the total Revenue, Cost and Net Profit?
    ---Business Question: What is the overall financial performance of the business?
	
SELECT SUM(p.unit_price_usd * s.quantity) AS grand_total_revenue,
SUM(s.Quantity *p.unit_cost_usd  ) AS Total_Cost,
SUM(s.Quantity * (p.unit_price_usd - p.unit_cost_usd  )) AS Net_Profit
FROM Products AS p
JOIN Sales AS s
ON p.productkey= s.productkey

---2. What is the overall Profit Margin?
    ---Business Question: How profitable is the company overall?
	
SELECT (SUM(s.Quantity * (p.unit_price_usd - p.unit_cost_usd  ))/SUM(p.unit_price_usd * s.quantity))*100 as Net_Profit_Margin 
FROM Products AS p
JOIN Sales AS s
ON p.productkey= s.productkey 

---3. What is the Yearly Revenue and Profit Trend?
   ---Business Question: How has financial performance changed over the years?
   
SELECT EXTRACT(YEAR FROM s.order_date) AS Sales_Year,SUM(p.unit_price_usd * s.quantity) AS Revenue,
SUM(s.Quantity * (p.unit_price_usd - p.unit_cost_usd)) AS Profit
FROM Products AS p
JOIN Sales AS s
ON p.productkey= s.productkey
GROUP BY EXTRACT(YEAR FROM s.order_date)
ORDER BY Sales_YEAR

---4. What is the Monthly Revenue Trend?
   ---Business Question: Which months show strong or weak sales performance?
   
SELECT EXTRACT(YEAR FROM s.order_date) AS Sales_Year,
EXTRACT(month FROM s.order_date) AS Month_number,
TO_CHAR(order_date, 'Month') AS month_name,  
SUM(p.unit_price_usd * s.quantity)AS Revenue
FROM Products AS p
JOIN Sales AS s
ON p.productkey= s.productkey
GROUP BY EXTRACT(month FROM s.order_date), EXTRACT(YEAR FROM s.order_date),TO_CHAR(order_date, 'Month')
ORDER BY month_number,Sales_Year

---5. Which Product Categories Generate the Highest Revenue?
   ---Business Question: Which categories are the biggest contributors to sales?
   
SELECT p.category,SUM(p.unit_price_usd * s.quantity) AS Revenue FROM Products AS p
JOIN Sales AS s
ON p.productkey= s.productkey
GROUP BY p.category
ORDER BY Revenue DESC

---6. Which Product Categories Generate the Highest Profit?
   ---Business Question: Which categories are the most profitable, rather than simply generating the most sales?
   
SELECT p.category,ROUND(SUM(s.Quantity * (p.unit_price_usd - p.unit_cost_usd))) AS Profit,
ROUND((SUM(s.Quantity * (p.unit_price_usd - p.unit_cost_usd  ))/SUM(p.unit_price_usd * s.quantity))*100) AS Profit_margin,
ROUND(SUM(p.unit_price_usd * s.quantity)) AS Revenue,
ROUND(SUM(s.Quantity *p.unit_cost_usd  )) AS Total_Cost
FROM Products AS p
JOIN Sales AS s
ON p.productkey= s.productkey
GROUP BY p.category
ORDER BY Profit DESC

---7. What are the Top 10 Products by Revenue?
   ---Business Question: Which individual products contribute the most revenue?
   
SELECT p.ProductKey,p.product_name,p.Category,p.Subcategory,ROUND(SUM(p.unit_price_usd * s.quantity)) AS Revenue 
FROM Products AS p
JOIN Sales AS s
ON p.productkey= s.productkey
GROUP BY p.ProductKey,p.product_name,p.Category,p.Subcategory
ORDER BY Revenue DESC
LIMIT 10;

---8. What are the Top 3 Products Within Each Category?
   ---Business Question: What are the best-performing products within each product category?
   
WITH Product_Revenue AS (
    SELECT p.category,p.productkey,p.product_name,SUM(s.quantity * p.unit_price_usd) AS revenue
    FROM sales s
    JOIN products p
    ON s.productkey = p.productkey
    GROUP BY p.category,p.productkey,p.product_name
),
Ranked_Products AS (SELECT *,RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS product_rank
FROM Product_Revenue
)
SELECT category,productkey,product_name,ROUND(revenue, 2) AS revenue,product_rank
FROM Ranked_Products
WHERE product_rank <= 3
ORDER BY category, product_rank;

---9. What Percentage of Total Revenue Does Each Category Contribute?
   ---Business Question: How important is each category to overall company revenue?
   
SELECT p.category,ROUND(SUM(s.quantity * p.unit_price_usd)/ SUM(SUM(s.quantity * p.unit_price_usd)) OVER () * 100,2) AS revenue_percentage
FROM sales s
JOIN products p
ON s.productkey = p.productkey
GROUP BY p.category
ORDER BY revenue_percentage DESC;

---10. How Does Online vs. In-Store Revenue Compare?
   ---FRD specifies: StoreKey = 0 → Online , Otherwise → In-Store.
   
SELECT
    CASE
    WHEN s.storekey = 0 THEN 'Online'
    ELSE 'In-Store'
    END AS store_type,
    ROUND(SUM(s.quantity * p.unit_price_usd), 2) AS revenue
FROM sales s
JOIN products p
ON s.productkey = p.productkey
GROUP BY
    CASE
    WHEN s.storekey = 0 THEN 'Online'
    ELSE 'In-Store'
    END
ORDER BY revenue DESC;

---11. Which States Generate the Highest Revenue?
   ---Business Question: Which geographical markets contribute most to sales?

SELECT c.state,ROUND(SUM(s.quantity * p.unit_price_usd), 2) AS revenue FROM sales AS s
JOIN products AS p
ON s.productkey = p.productkey
join customers AS c
ON c.customerkey=s.customerkey
WHERE s.StoreKey <> 0
GROUP BY c.state
ORDER BY revenue DESC

---12. Which Stores Generate the Highest Revenue?
   ---Business Question: Which individual physical stores are performing best?
   
SELECT s.storekey,ROUND(SUM(s.quantity * p.unit_price_usd), 2) AS revenue FROM sales AS s
JOIN products AS p
ON s.productkey = p.productkey
WHERE s.StoreKey <> 0
GROUP BY s.storekey
ORDER BY revenue DESC

---13. Does Store Size Relate to Revenue?
   ---Business Question: Do larger stores generate higher revenue?
   
SELECT st.StoreKey,st.State,st.square_meters,ROUND(SUM(s.Quantity *p.unit_price_usd ), 2) AS Revenue
FROM Sales AS s
JOIN Products AS p
ON s.ProductKey = p.ProductKey
JOIN Stores AS st
ON s.StoreKey = st.StoreKey
WHERE s.StoreKey <> 0
GROUP BY st.StoreKey,st.State,st.square_meters
ORDER BY Revenue DESC;

---14. Who Are the Top 10 Customers by Spending?
   ---Business Question: Which customers contribute the most revenue?
   
SELECT c.CustomerKey,c.Name,c.Gender,c.State,
ROUND(SUM(s.Quantity * p.unit_price_usd), 2) AS Total_Spending,
COUNT(DISTINCT s.order_number) AS Order_Count
FROM Sales AS s
JOIN Customers AS c
ON s.CustomerKey = c.CustomerKey
JOIN Products AS p
ON s.ProductKey = p.ProductKey
GROUP BY c.CustomerKey,c.Name,c.Gender,c.State
ORDER BY Total_Spending DESC
LIMIT 10;

---15. What Percentage of Customers Are One-Time vs. Repeat Buyers?
   ---Business Question: How strong is customer retention?

WITH orders AS(
SELECT customerkey,COUNT(DISTINCT order_number) AS Order_Count
FROM sales 
GROUP BY  customerkey
),
Customer_type AS(
SELECT customerkey,
CASE
WHEN Order_Count=1 THEN 'One-time-buyers'
ELSE 'Repeat_buyers'
END AS Customer_type
 FROM orders
)
SELECT  Customer_Type,COUNT(*) AS Customer_Count,ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),2) AS Customer_Percentage
FROM Customer_Type
GROUP BY Customer_Type
ORDER BY Customer_Count DESC;

---16. Which Age Group Generates the Highest Revenue?
   ---FRD defines these age groups: <25
                                    25–34
                                    35–44
                                    45–54
                                    55+
									
SELECT c."Age Group",round(sum(s.Quantity * p.unit_price_usd)) AS revenue
FROM Sales AS s
JOIN products AS p
ON s.productkey=p.productkey
JOIN customers AS c
ON s.customerkey=c.customerkey
GROUP BY c."Age Group"
ORDER BY revenue desc

---17. What is the Average Delivery Time by State?
   ---Business Question: Which states have slower fulfillment?
   
SELECT c.state,avg(s.delivery_days) AS average_delivery_days FROM customers AS c
JOIN sales AS s 
ON s.customerkey=c.customerkey
GROUP BY c.state

---18. Which States Have the Most Delayed Orders?
   ---FRD defines delayed orders as orders taking more than 7 days
   
SELECT c.State,COUNT(*) AS Delayed_Orders
FROM Sales s
JOIN Customers c
ON s.CustomerKey = c.CustomerKey
WHERE s.Delivery_Days > 7
GROUP BY c.State
ORDER BY Delayed_Orders DESC;
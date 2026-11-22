# Global Electronics Retailer – Sales & Business Performance

## 📌 Project Overview

This project focuses on analyzing the sales and business performance of a fictional **Global Electronics Retailer** using the **Maven Analytics – Global Electronics Retailer** dataset.

The project integrates sales, customer, product, store, and exchange-rate data to provide a consolidated view of business performance. The analysis covers **revenue, cost, profit, profitability, product performance, sales channels, stores, customers, and delivery operations**.

The final solution combines **PostgreSQL SQL analysis** with an interactive **Power BI dashboard** to transform raw business data into meaningful insights for decision-making.

The project was developed based on defined **Business Requirements (BRD)** and **Functional Requirements (FRD)** to ensure that the final dashboard addresses the required business objectives.

---

## 🎯 Business Objective

The main objective of this project is to understand global business performance.

The analysis focuses on:

* Monitoring revenue, cost, profit, and profit margin
* Tracking sales performance over time
* Comparing Online and In-Store sales
* Identifying high-performing products and categories
* Comparing store and regional performance
* Understanding customer demographics and purchasing behavior
* Measuring delivery performance and identifying delayed orders
* Providing interactive filtering for business users

---

## 🗂️ Dataset

**Dataset:** Maven Analytics – Global Electronics Retailer
**Link: https://mavenanalytics.io/data-playground/global-electronics-retailer**
The dataset contains information related to:

* Sales transactions
* Customers
* Products
* Stores
* Exchange Rates
* Dates(Created manually from order_date column)

The data model follows a **Star Schema** consisting of a Sales fact table and supporting dimension tables.

### Main Tables

| Table          | Description                                                         |
| -------------- | ------------------------------------------------------------------- |
| Sales          | Contains order-level and transaction-level sales information        |
| Customers      | Contains customer demographics and location information             |
| Products       | Contains product, category, subcategory, cost and price information |
| Stores         | Contains store location, size and opening-date information          |
| Exchange_Rates | Contains currency exchange-rate information                         |
| Date           | Master calendar/date dimension                                      |

---

## 🏗️ Data Model

The project follows a **Star Schema** architecture.

```text
                    ┌──────────────┐
                    │  Customers   │
                    └──────┬───────┘
                           │
                           │ CustomerKey
                           ▼
┌──────────────┐      ┌───────────┐      ┌──────────────┐
│   Products   │─────►│   Sales   │◄─────│    Stores    │
└──────────────┘      └─────┬─────┘      └──────────────┘
                            │
                            │ Order Date
                            ▼
                       ┌──────────┐
                       │   Date   │
                       └──────────┘

                  Exchange_Rates
```

### Key Relationships

* Sales → Customers using `CustomerKey`
* Sales → Products using `ProductKey`
* Sales → Stores using `StoreKey`
* Sales → Date using `Order Date`
* Exchange_Rates → Date using `Date`

---

## 🧹 Data Cleaning & Transformation

Before analysis and dashboard development, the data was prepared according to the defined functional requirements.

The main transformations include:

* Converting date fields into proper date formats
* Converting quantities into numeric/whole-number values
* Cleaning currency and price fields
* Creating a **Sales Channel** field
* Creating **Delivery Days**
* Creating customer **Age** and **Age Group**
* Removing invalid records
* Handling missing delivery dates

### Sales Channel Logic

```text
StoreKey = 0  → Online
StoreKey > 0  → In-Store
```

This distinction is used throughout the channel analysis.

### Age Groups

Customers are classified into:

* `<25`
* `25–34`
* `35–44`
* `45–54`
* `55+`

### Delivery Logic

```text
Delivery Days = Delivery Date - Order Date
```

Orders taking more than **7 days** are classified as delayed for delivery analysis.

---

## 📊 Key KPIs

The project calculates the following major business KPIs:

### Revenue

```text
Revenue = Quantity × Unit Price
```

### Cost

```text
Cost = Quantity × Unit Cost
```

### Net Profit

```text
Net Profit = Revenue - Cost
```

### Profit Margin

```text
Profit Margin % = Net Profit / Revenue × 100
```

### Total Orders

```text
Total Orders = DISTINCT COUNT of Order Number
```

### Average Order Value

```text
AOV = Revenue / Total Orders
```

### Total Units Sold

```text
Total Units = SUM(Quantity)
```

### Average Delivery Days

```text
Average Delivery Days = AVERAGE(Delivery Days)
```

These calculations follow the KPI specifications defined in the FRD.

---

# 🛠️ Tools & Technologies

* **PostgreSQL** – Data storage, SQL querying and business analysis
* **SQL** – Data analysis and business question solving
* **Power BI** – Interactive dashboard and visualization
* **Excel / Power Query** – Data preparation and validation
* **Maven Analytics Dataset** – Source dataset

---

# 🔍 SQL Analysis

A set of business questions was developed and answered using PostgreSQL.

The analysis includes:

### Financial Analysis

* Total Revenue, Cost and Net Profit
* Overall Profit Margin
* Yearly Revenue and Profit Trend
* Monthly Revenue Trend

### Product Analysis

* Revenue by Product Category
* Profit by Product Category
* Top 10 Products by Revenue
* Top 3 Products within Each Category
* Revenue Contribution by Category

### Channel & Store Analysis

* Online vs. In-Store Revenue
* Revenue by State
* Revenue by Store
* Store Size vs. Revenue

### Customer Analysis

* Top 10 Customers by Spending
* One-Time vs. Repeat Buyers
* Revenue by Customer Age Group

### Delivery Analysis

* Average Delivery Time by State
* Delayed Orders by State
* Orders taking more than 7 days to deliver

The SQL analysis uses techniques including **JOINs, GROUP BY, aggregate functions, CASE statements, CTEs, window functions, filtering, ranking and ordering**.

---

# 📈 Power BI Dashboard

The completed Power BI dashboard follows the dashboard specifications defined in the FRD.

## 1. Executive Overview

The overview page provides a high-level view of business performance.

### Key Components

* Revenue
* Total Net Profit
* Profit Margin %
* Total Orders
* Average Order Value
* Yearly Revenue and Profit Trend
* Revenue Contribution by Region
* Online vs. In-Store Distribution
* Top 5 Products by Revenue

### Filters

* Year
* State
* Channel

---

## 2. Sales & Profitability Analysis

This page focuses on revenue, cost and profitability across products and categories.

### Key Components

* Monthly Revenue vs. Cost
* Net Profit Margin %
* Profit Breakdown by Category
* Unit Price vs. Profit Margin
* Category and Subcategory Revenue
* Net Profit and Margin Analysis

### Filters

* Year
* Subcategory
* Category

---

## 3. Channel & Store Analysis

This page compares online and physical-store performance and evaluates store-level performance.

### Key Components

* Online vs. Physical Store Sales Trend
* Store Area vs. Revenue
* Revenue and Profit by Store
* Average Store Operating Age

### Filters

* Year
* State
* Sales Channel

---

## 4. Customer Insights

This page analyzes customer demographics and purchasing behavior.

### Key Components

* Customer Distribution by Age Group and Gender
* Top 10 Customers by Revenue
* Customer Order Count
* One-Time vs. Repeat Buyers

### Filters

* Gender
* State
* Age Group

---

## 5. Delivery & Fulfillment Operations

This page focuses on delivery performance and fulfillment delays.

### Key Components

* Average Delivery Days
* Maximum Delivery Days
* Total Delayed Orders
* Delivery Duration Trend
* Average Delivery Days by State
* Missing Delivery Dates
* Delayed Orders

### Filters

* Year
* State
* Sales Channel

---

# 📌 Key Business Insights

The analysis provides several important business insights, including:

* **In-Store sales contribute a larger share of revenue than Online sales.**
* **Computers are one of the strongest product categories in terms of revenue and profitability.**
* Certain states contribute significantly more revenue than other geographical markets.
* A relatively small group of customers contributes a significant amount of individual customer revenue.
* The customer base contains both one-time and repeat buyers, providing an opportunity to improve customer retention.
* Delivery performance varies across states, with some locations experiencing higher delivery times and delayed orders.
* Product revenue and profitability do not always move together, making margin analysis important when evaluating product performance.

These insights support management decisions related to sales growth, product strategy, customer retention, store performance and operational efficiency.

---

# 📁 Project Structure

```text
Global-Electronics-Retailer/
|
|-----Data/
|       |--Processed/
|       |     |--Customers.csv
|       |     |--Exchange_Rates.csv
|       |     |--Products.csv
|       |      |--Sales.csv
|       |      |--Stores.csv
|       |--Raw/
|             |--Customers.csv
|             |--Exchange_Rates.csv
|             |--Products.csv
|             |--Sales.csv
|             |--Stores.csv
|--Dashboard/
|        |--Dashboard.pbix
|        |--Dashboard.pdf
|        |--Channel & Store_Snapshot.jpg
|        |--Customer Insights_Snapshot.jpg
|        |--Delivery & Fullfillment_Snapshot.jpg
|        |--Overview_Snapshot.jpg
|        |--Sales & Profitability_Snapshot.jpg
|
|--Business_Requirement_Document (BRD).pdf
|
|--DATA DICTIONARY.pdf
|
|--Functional_Requirement_Document (FRD).pdf
|
|--SQL_Questions.sql
|
|--Project_Report.pdf
|
|--README.md
```
---
# 💡 Business Value

This project demonstrates how raw transactional data can be transformed into a structured business intelligence solution.

The final solution enables decision-makers to:

* Monitor overall business performance
* Identify profitable products and categories
* Compare Online and In-Store channels
* Evaluate store and regional performance
* Understand customer behavior
* Identify delivery issues
* Explore business performance through interactive dashboard filters

The project therefore combines **data preparation, SQL analysis, business requirements, data modeling, KPI development and Power BI visualization** into one end-to-end analytics solution.

---



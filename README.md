# Data Warehouse Modeling: Baby Name Popularity Analysis 👶

This project demonstrates a fundamental data warehousing workflow using Google BigQuery. We build a **Star Schema** to analyze USA baby name popularity from the 2000s, addressing a business problem for a fictional retailer, **BrightBeginnings**.

The primary goal is to identify the **Top 5 most popular male names for each state** from 2000 to 2009 to inform inventory and marketing strategies.

---

## 🎯 Business Problem

* **Organization:** BrightBeginnings, a national baby-products retailer.
* **Goal:** Plan state-level inventory and marketing for the 2000s by aligning product lines (e.g., personalized items, name-printed SKUs) with the most popular baby names.
* **Need:** Identify the Top 5 male names per state in the 2000s and understand how popularity shifts by year to inform state-specific product assortments and seasonal campaigns.
* **Success looks like:**
    * A ranked list of the Top 5 male names for each state (2000–2009).
    * Counts of births to size inventory appropriately per state.
    * The ability to easily slice data by state, year, and gender using the star schema.

---

## 📊 Data Model: The Star Schema

This project uses a star schema, a classic data warehouse design that separates data into a central **Fact table** (containing quantitative measurements) and surrounding **Dimension tables** (containing descriptive context).

* **`fact_names` (Fact Table):** Contains the core measurable event—the number of births for a given name, in a specific year, state, and for a specific gender.
* **`dim_time` (Dimension Table):** Provides temporal context like year and decade.
* **`dim_state` (Dimension Table):** Provides geographical context, including state codes and categories.
* **`dim_gender` (Dimension Table):** Provides descriptive labels for gender.

This design optimizes queries for analytics and reporting.


---

## 🚀 How to Run this Project

To replicate this analysis, follow these steps:

1.  **Prerequisites:** Ensure you have a Google Cloud account with access to the BigQuery Console.

2.  **Create a Dataset:** In your BigQuery project, create a new dataset named `class_dw`.

3.  **Run the SQL Scripts:** Execute the code blocks below in the specified order.

    > **Important:** In each script, you must replace **`PROJECT_ID`** with your actual Google Cloud Project ID.

---

### Short Reflection 

1. **Why do we separate data into fact and dimension tables?** We separate data into fact and dimension tables to make databases faster, simpler, and more reliable.

Fact tables store key measurements or events (like sales totals or birth counts).

Dimension tables store the context for those events (like customer details, product descriptions, or locations).

This "star schema" design significantly improves query speed because analytics often involve summing up millions of facts but only need a few descriptive details from the smaller dimension tables. It also reduces data redundancy; for example, a state name like "California" is stored once in a dimension table instead of being repeated for every single birth record in a giant table.
   
2. **What challenges might arise if we stored everything in one large table?**Storing everything in one large table (a "denormalized" table) creates several major problems:

Slow Performance: Queries have to scan through massive amounts of repetitive data, making analysis and reporting incredibly slow. 

Data Redundancy: Repeating descriptive information for every single entry wastes enormous amounts of storage space.

Maintenance Nightmares: If you need to update a piece of information (like changing a category name), you have to find and change it in potentially millions of rows. This is inefficient and greatly increases the risk of errors and data inconsistencies.


---

### 1. Create the Fact Table (`fact_names.sql`)

This script creates the central fact table containing the core birth count measures.

```sql
CREATE OR REPLACE TABLE `PROJECT_ID.class_dw.fact_names` AS
SELECT
  INITCAP(LOWER(name)) AS name_standardized,
  gender,
  UPPER(state) AS state_code,
  year,
  number AS births_count,
  DATE(CONCAT(CAST(FLOOR(year/10)*10 AS STRING), '-01-01')) AS decade_start
FROM `bigquery-public-data.usa_names.usa_1910_2013`
WHERE name IS NOT NULL AND number > 0;


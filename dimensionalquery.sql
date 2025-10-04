CREATE OR REPLACE TABLE `j4a-midterm-project-473002.class_dw_sw1.dim_time` AS
SELECT DISTINCT
  year,
  DATE(CONCAT(CAST(FLOOR(year/10)*10 AS STRING), '-01-01')) AS decade_start,
  CASE
    WHEN year BETWEEN 1910 AND 1949 THEN 'Early 20th Century'
    WHEN year BETWEEN 1950 AND 1999 THEN 'Late 20th Century'
    ELSE '21st Century'
  END AS period_label
FROM `bigquery-public-data.usa_names.usa_1910_2013`;

CREATE OR REPLACE TABLE `j4a-midterm-project-473002.class_dw_sw1.dim_state` AS
SELECT DISTINCT
  UPPER(state) AS state_code,
  CASE
    WHEN state IN ('CA','TX','FL','NY') THEN 'Large State'
    ELSE 'Other State'
  END AS state_category
FROM `bigquery-public-data.usa_names.usa_1910_2013`
WHERE state IS NOT NULL;

CREATE OR REPLACE TABLE `j4a-midterm-project-473002.class_dw_sw1.dim_gender` AS
SELECT DISTINCT
  gender,
  CASE
    WHEN gender = 'M' THEN 'Male'
    WHEN gender = 'F' THEN 'Female'
    ELSE 'Unknown'
  END AS gender_label
FROM `bigquery-public-data.usa_names.usa_1910_2013`;
CREATE OR REPLACE TABLE `j4a-midterm-project-473002.class_dw_sw1.fact_names` AS
SELECT
  INITCAP(LOWER(name)) AS name_standardized,
  gender,
  UPPER(state) AS state_code,
  year,
  number AS births_count,
  DATE(CONCAT(CAST(FLOOR(year/10)*10 AS STRING), '-01-01')) AS decade_start
FROM `bigquery-public-data.usa_names.usa_1910_2013`
WHERE name IS NOT NULL AND number > 0;


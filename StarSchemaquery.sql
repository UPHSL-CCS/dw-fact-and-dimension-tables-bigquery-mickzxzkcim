WITH RankedNames AS (
  SELECT
    fn.name_standardized,
    ds.state_code,
    SUM(fn.births_count) AS total_births,
    RANK() OVER(PARTITION BY ds.state_code ORDER BY SUM(fn.births_count) DESC) as name_rank
  FROM
    `j4a-midterm-project-473002.class_dw_sw1.fact_names` AS fn
  JOIN
    `j4a-midterm-project-473002.class_dw_sw1.dim_state` AS ds ON fn.state_code = ds.state_code
  JOIN
    `j4a-midterm-project-473002.class_dw_sw1.dim_time` AS dt ON fn.year = dt.year
  JOIN
    `j4a-midterm-project-473002.class_dw_sw1.dim_gender` AS dg ON fn.gender = dg.gender
  WHERE
    dt.year BETWEEN 2000 AND 2009
    AND dg.gender_label = 'Male'
  GROUP BY
    fn.name_standardized,
    ds.state_code
)
SELECT
  state_code,
  name_standardized,
  total_births,
  name_rank
FROM
  RankedNames
WHERE
  name_rank <= 5
ORDER BY
  state_code,
  name_rank;
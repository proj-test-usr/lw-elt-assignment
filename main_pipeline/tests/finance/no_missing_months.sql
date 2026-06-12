-- =========================================================
-- Test: no_missing_months
-- Purpose:
--   Ensures that the final MRR mart has continuous monthly
--   coverage between min and max observed months.
--
-- Why it matters:
--   Missing months would break time-series analysis in BI tools
-- =========================================================

WITH months AS (

    SELECT DISTINCT
        month
    FROM {{ ref('fct_mrr_by_school_use_case_country_month') }}

),

min_max AS (

    SELECT
        MIN(month) AS min_month,
        MAX(month) AS max_month
    FROM months

),

expected AS (

    SELECT
        month_start AS month
    FROM {{ ref('dim_months') }}
    WHERE month_start BETWEEN (SELECT min_month FROM min_max)
                          AND (SELECT max_month FROM min_max)

)

SELECT *
FROM expected
WHERE month NOT IN (SELECT month FROM months)
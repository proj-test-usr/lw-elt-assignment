-- =========================================================
-- Dimension: dim_months
-- Purpose:
--   Provides a continuous monthly calendar spine used for:
--   - MRR aggregation
--   - revenue reporting consistency
--   - time-series completeness checks
--
-- Design choice:
--   Generates a fixed 20-year rolling calendar to avoid gaps
--   caused by sparse transactional data.
-- =========================================================

{{ config(materialized='table', tags=['intermediate', 'dimension']) }}

WITH months AS (

    SELECT
        DATE '2020-01-01'
        + (INTERVAL '1 month' * i) AS month_start
    FROM range(240) AS t(i)   -- 12*20 months = 20 years

)

SELECT

    CAST(month_start AS DATE) AS month_start,
    EXTRACT(YEAR FROM month_start) AS year,
    EXTRACT(MONTH FROM month_start) AS month_num,
    STRFTIME(month_start, '%Y-%m') AS year_month

FROM months
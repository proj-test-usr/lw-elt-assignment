{{ config(
    materialized='table',
    tags=["mart", "finance", "gold"]
) }}

SELECT
    month,
    use_case,
    country,
    SUM(mrr_usd) AS mrr_usd
FROM {{ ref('int_mrr_allocations') }}
GROUP BY 1, 2, 3
{{ config(
    materialized='table',
    tags=["mart", "finance", "gold"]
) }}

SELECT
    month,
    SUM(mrr_usd) AS mrr_usd
FROM {{ ref('int_mrr_allocations') }}
GROUP BY 1
ORDER BY 1
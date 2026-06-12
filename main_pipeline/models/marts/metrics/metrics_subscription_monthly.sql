{{ config(
    materialized='table',
    tags=["metrics", "finance", "gold"]
) }}

WITH active_subscriptions AS (
    SELECT
        month,
        COUNT(DISTINCT subscription_id) AS active_subscriptions
    FROM {{ ref('int_subscription_months') }}
    GROUP BY 1
),

new_subscriptions AS (
    SELECT
        DATE_TRUNC('month', start_date) AS month,
        COUNT(DISTINCT subscription_id) AS new_subscriptions
    FROM {{ ref('stg_subscriptions') }}
    GROUP BY 1
),

ending_subscriptions AS (
    SELECT
        DATE_TRUNC('month', billed_until_date) AS month,
        COUNT(DISTINCT subscription_id) AS ending_subscriptions
    FROM {{ ref('stg_subscriptions') }}
    GROUP BY 1
),

months AS (
    SELECT month_start AS month
    FROM {{ ref('dim_months') }}
)

SELECT
    m.month,
    COALESCE(a.active_subscriptions, 0) AS active_subscriptions,
    COALESCE(n.new_subscriptions, 0) AS new_subscriptions,
    COALESCE(e.ending_subscriptions, 0) AS ending_subscriptions
FROM months m

LEFT JOIN active_subscriptions a
    ON m.month = a.month
LEFT JOIN new_subscriptions n
    ON m.month = n.month
LEFT JOIN ending_subscriptions e
    ON m.month = e.month

WHERE m.month BETWEEN
    (SELECT MIN(DATE_TRUNC('month', start_date)) FROM {{ ref('stg_subscriptions') }})
    AND
    (SELECT MAX(DATE_TRUNC('month', billed_until_date)) FROM {{ ref('stg_subscriptions') }})

ORDER BY 1
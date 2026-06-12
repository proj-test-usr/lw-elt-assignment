{{ config(
    materialized='table',
    tags=["metrics", "finance", "gold"]
) }}

WITH monthly_mrr AS (
    SELECT
        month,
        SUM(mrr_usd) AS mrr_usd
    FROM {{ ref('int_mrr_allocations') }}
    GROUP BY 1
),

churned_mrr AS (
    SELECT
        DATE_TRUNC('month', s.billed_until_date) AS month,
        SUM(a.mrr_usd) AS churned_mrr
    FROM {{ ref('int_mrr_allocations') }} a
    JOIN {{ ref('stg_invoices') }} i
        ON a.invoice_id = i.invoice_id
    JOIN {{ ref('stg_subscriptions') }} s
        ON i.subscription_id = s.subscription_id
    WHERE LOWER(s.status) = 'cancelled'
    GROUP BY 1
),

final AS (
    SELECT
        m.month,
        m.mrr_usd,
        COALESCE(c.churned_mrr, 0) AS churned_mrr,
        m.mrr_usd - LAG(m.mrr_usd) OVER (ORDER BY m.month) AS net_mrr_change
    FROM monthly_mrr m
    LEFT JOIN churned_mrr c
        ON m.month = c.month
)

SELECT *
FROM final
ORDER BY month
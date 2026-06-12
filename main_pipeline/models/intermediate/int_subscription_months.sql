-- =========================================================
-- Intermediate Model: int_subscription_months
-- Purpose:
--   Expands subscriptions into monthly grain.
--   Used for churn, retention, and lifecycle analysis.
-- =========================================================

{{ config(
    materialized='view',
    tags=['intermediate', 'finance_engine']
) }}

WITH subscriptions AS (
    SELECT
        subscription_id,
        CAST(start_date AS DATE) AS start_date,
        CAST(billed_until_date AS DATE) AS billed_until_date,
        DATE_TRUNC('month', start_date) AS start_month,
        DATE_TRUNC('month', billed_until_date) AS end_month
    FROM {{ ref('stg_subscriptions') }}
),

months AS (
    SELECT month_start
    FROM {{ ref('dim_months') }}
)

SELECT
    s.subscription_id,
    m.month_start AS month
FROM subscriptions s

JOIN months m
    ON m.month_start BETWEEN s.start_month AND s.end_month
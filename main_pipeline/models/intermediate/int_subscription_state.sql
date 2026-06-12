-- =========================================================
-- Intermediate Model: int_subscription_state
-- Purpose:
--   Normalizes subscription lifecycle status.
--   Provides consistent flags for active vs cancelled states.
--
-- Used for:
--   churn analysis, cohort tracking, ARR modeling
-- =========================================================

{{ config(
    materialized='view',
    tags=['intermediate', 'finance_engine']
) }}

SELECT
    subscription_id,
    school_id,
    LOWER(status) AS subscription_status,
    CAST(start_date AS DATE) AS start_date,
    CAST(billed_until_date AS DATE) AS billed_until_date,
    CASE
        WHEN LOWER(status) = 'active' THEN TRUE
        ELSE FALSE
    END AS is_active,
    CASE
        WHEN LOWER(status) = 'cancelled' THEN TRUE
        ELSE FALSE
    END AS is_cancelled,
    DATE_TRUNC('month', start_date) AS start_month,
    DATE_TRUNC('month', billed_until_date) AS billed_until_month
FROM {{ ref('stg_subscriptions') }}
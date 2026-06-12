-- =========================================================
-- Staging Model: stg_subscriptions
-- Purpose:
--   Tracks subscription lifecycle and ownership.
--   Links schools to subscription contracts and billing state.
-- =========================================================

SELECT
    subscription_id,
    subscription_type,
    school_id,
    billing_method,
    LOWER(status) AS status,
    CAST(start_date AS DATE) AS start_date,
    CAST(billed_until_date AS DATE) AS billed_until_date
FROM {{ source('raw', 'subscriptions') }}
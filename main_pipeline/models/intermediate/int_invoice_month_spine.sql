-- =========================================================
-- Intermediate Model: int_invoice_month_spine
-- Purpose:
--   Expands each invoice into all months it spans.
--   Creates a time series backbone for revenue allocation.
-- =========================================================

{{ config(
    materialized='view',
    tags=['intermediate', 'invoice_shaping']
) }}

WITH invoice_bounds AS (
    SELECT * FROM {{ ref('int_invoice_bounds') }}
),

months AS (
    SELECT month_start
    FROM {{ ref('dim_months') }}
),

expanded AS (
    SELECT
        i.invoice_id,
        i.customer_id,
        i.subscription_id,
        i.product_id,
        i.amount_usd,
        i.billing_start_date,
        i.billing_end_date,
        m.month_start
    FROM invoice_bounds i
    JOIN months m
        ON m.month_start BETWEEN i.start_month AND i.end_month
)

SELECT * FROM expanded
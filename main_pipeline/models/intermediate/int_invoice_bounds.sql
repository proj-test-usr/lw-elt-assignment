-- =========================================================
-- Intermediate Model: int_invoice_bounds
-- Purpose:
--   Defines billing period boundaries for each invoice.
--   This is the foundation for MRR amortization logic.
--
-- Why it exists:
--   Revenue must be allocated across time, not recognized
--   in a single invoice month.
-- =========================================================

{{ config(
    materialized='view',
    tags=['intermediate', 'invoice_shaping']
) }}

SELECT
    invoice_id,
    customer_id,
    subscription_id,
    product_id,
    amount_usd,
    CAST(billing_start_date AS DATE) AS billing_start_date,
    CAST(billing_end_date AS DATE) AS billing_end_date,
    DATE_TRUNC('month', billing_start_date) AS start_month,
    DATE_TRUNC('month', billing_end_date) AS end_month
FROM {{ ref('stg_invoices') }}
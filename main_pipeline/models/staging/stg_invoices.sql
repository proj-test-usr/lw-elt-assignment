-- =========================================================
-- Staging Model: stg_invoices
-- Purpose:
--   Standardizes invoice-level financial data.
--   Ensures correct typing for monetary and date fields.
--
-- Critical for:
--   MRR allocation, revenue recognition, and reconciliation tests.
-- =========================================================

SELECT
    invoice_id,
    customer_id,
    subscription_id,
    product_id,
    CAST(invoice_date AS DATE) AS invoice_date,
    CAST(billing_start_date AS DATE) AS billing_start_date,
    CAST(billing_end_date AS DATE) AS billing_end_date,
    CAST(amount_usd AS DECIMAL(18,2)) AS amount_usd
FROM {{ source('raw', 'invoices') }}
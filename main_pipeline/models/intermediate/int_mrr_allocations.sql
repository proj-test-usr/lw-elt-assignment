-- =========================================================
-- Intermediate Model: int_mrr_allocations
-- Purpose:
--   Allocates invoice revenue evenly across billing months.
--
-- Core assumption:
--   Revenue is linear across invoice duration (no seasonality).
--
-- This is the PRIMARY MRR computation layer.
-- =========================================================

{{ config(
    materialized='view',
    tags=['intermediate', 'finance_engine']
) }}

WITH base AS (
    SELECT * FROM {{ ref('int_invoice_enriched') }}
),

month_counts AS (
    SELECT
        invoice_id,
        COUNT(*) AS month_count
    FROM base
    GROUP BY 1
)

SELECT
    b.invoice_id,
    b.month_start AS month,
    b.country,
    b.use_case,
    (b.amount_usd / mc.month_count) AS mrr_usd
FROM base b

JOIN month_counts mc
    ON b.invoice_id = mc.invoice_id
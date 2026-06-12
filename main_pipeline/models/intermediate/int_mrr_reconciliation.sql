-- =========================================================
-- Intermediate Model: int_mrr_reconciliation
-- Purpose:
--   Validates that invoice revenue is fully preserved
--   after allocation into monthly MRR.
--
-- Critical for:
--   Financial correctness and auditability.
-- =========================================================

{{ config(
    materialized='view',
    tags=['intermediate', 'finance_engine']
) }}

WITH invoices AS (
    SELECT
        invoice_id,
        amount_usd
    FROM {{ ref('stg_invoices') }}
),

allocated AS (
    SELECT
        invoice_id,
        SUM(mrr_usd) AS allocated_mrr
    FROM {{ ref('int_mrr_allocations') }}
    GROUP BY 1
)

SELECT
    i.invoice_id,
    i.amount_usd,
    a.allocated_mrr,
    (i.amount_usd - COALESCE(a.allocated_mrr, 0)) AS difference,
    CASE
        WHEN ABS(i.amount_usd - COALESCE(a.allocated_mrr, 0)) < 0.01
        THEN 'PASS'
        ELSE 'FAIL'
    END AS reconciliation_status
FROM invoices i

LEFT JOIN allocated a
    ON i.invoice_id = a.invoice_id
-- =========================================================
-- Test: no_duplicate_months
-- Purpose:
--   Ensures each invoice-month allocation is unique.
--
-- Why it matters:
--   Prevents double counting revenue in downstream aggregation.
-- =========================================================

SELECT
    invoice_id,
    month,
    COUNT(*) AS row_count
FROM {{ ref('int_mrr_allocations') }}
GROUP BY
    invoice_id,
    month
HAVING COUNT(*) > 1
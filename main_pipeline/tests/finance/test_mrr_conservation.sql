-- =========================================================
-- Test: mrr_conservation
-- Purpose:
--   Ensures that invoice-level revenue is fully preserved
--   after allocation into monthly MRR.
--
-- Business rule:
--   SUM(allocated MRR per invoice) must equal invoice amount.
--
-- Why it matters:
--   Core financial integrity check of the model.
-- =========================================================

SELECT *
FROM {{ ref('int_mrr_reconciliation') }}
WHERE reconciliation_status = 'FAIL'
-- =========================================================
-- Intermediate Model: int_invoice_enriched
-- Purpose:
--   Enriches invoice-month grain with:
--   - customer geography
--   - subscription metadata
--   - school use case segmentation
--
-- Used for:
--   MRR slicing by country + use case
-- =========================================================

{{ config(
    materialized='view',
    tags=['intermediate', 'enrichment']
) }}

SELECT
    m.*,
    c.customer_id,
    c.country,
    s.school_id,
    sc.use_case
FROM {{ ref('int_invoice_month_spine') }} m

LEFT JOIN {{ ref('stg_customers') }} c
    ON m.customer_id = c.customer_id
LEFT JOIN {{ ref('stg_subscriptions') }} s
    ON m.subscription_id = s.subscription_id
LEFT JOIN {{ ref('stg_schools') }} sc
    ON s.school_id = sc.school_id
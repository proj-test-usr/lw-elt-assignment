-- =========================================================
-- Staging Model: stg_products
-- Purpose:
--   Standardizes product catalog information.
--   Normalizes billing frequency for revenue modeling logic.
-- =========================================================

SELECT
    product_id,
    product_name,
    LOWER(billing_frequency) AS billing_frequency
FROM {{ source('raw', 'products') }}
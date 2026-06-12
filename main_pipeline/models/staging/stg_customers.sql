-- =========================================================
-- Staging Model: stg_customers
-- Purpose:
--   Standardizes customer master data for downstream joins.
--   Normalizes country field for consistent aggregation.
-- =========================================================

SELECT
    customer_id,
    company_name,
    LOWER(country) AS country,
    default_billing_method
FROM {{ source('raw', 'customers') }}
-- =========================================================
-- Staging Model: stg_schools
-- Purpose:
--   Maps schools to their business use case.
--   This is a key dimension for MRR segmentation.
-- =========================================================

SELECT
    school_id,
    school_name,
    LOWER(use_case) AS use_case
FROM {{ source('raw', 'schools') }}
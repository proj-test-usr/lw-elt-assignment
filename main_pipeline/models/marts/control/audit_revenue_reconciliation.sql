{{ config(
    materialized='table',
    tags=["metrics", "finance", "gold"]
) }}

SELECT
    invoice_id,
    amount_usd,
    allocated_mrr,
    difference,
    reconciliation_status
FROM {{ ref('int_mrr_reconciliation') }}
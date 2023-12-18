{{ config(enabled=block_bigquery()) }}

with
    aggregated as (
        ({{view_azure_security_policy_parameters()}})
    )

select *
from aggregated
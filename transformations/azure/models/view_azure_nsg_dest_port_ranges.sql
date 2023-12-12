{{ config(enabled=block_bigquery()) }}

with
    aggregated as (
        ({{view_azure_nsg_dest_port_ranges()}})
    )

select *
from aggregated
with
    aggregated as (
        ({{view_azure_nsg_rules()}})
    )

select *
from aggregated
with
    aggregated as (
    ({{unused_dynamodb_tables()}})
    {{ union() }}
    -- depends_on: {{ ref('aws_cost__by_resources') }}
    ({{unused_ec2_internet_gateways()}})
    {{ union() }}
    ({{unused_ecr_repositories()}})
    {{ union() }}
    ({{unused_acm_certs()}})
    )
select 
        {{ gen_timestamp() }},
        aggregated.*
from aggregated 
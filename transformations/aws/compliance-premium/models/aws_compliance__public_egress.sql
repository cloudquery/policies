with
    aggregated as (
        ({{ public_egress_sg_and_routing_instances('public_egress','ec2-all-instances-with-routes-and-security-groups') }})
        {{ union() }}
        ({{ functions_with_public_egress('public_egress','lambda-functions') }})
        {{ union() }}
        ({{ public_egress_sg_instances('public_egress','ec2-instances') }})
    )
select 
        {{ gen_timestamp() }},
        aggregated.*
from aggregated

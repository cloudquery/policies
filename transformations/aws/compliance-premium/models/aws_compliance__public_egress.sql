{{ config(enabled=block_bigquery() and block_snowflake()) }}

with
    aggregated as (
        ({{ public_egress_sg_and_routing_instances('public_egress','ec2-all-instances-with-routes-and-security-groups') }})
        UNION
        ({{ functions_with_public_egress('public_egress','lambda-functions') }})
        UNION
        ({{ public_egress_sg_instances('public_egress','ec2-instances') }})
    )
select 
        ('{{ run_started_at }}')::timestamp as policy_execution_time,
        aggregated.*
from aggregated

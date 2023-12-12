{{ config(enabled=block_bigquery() and block_snowflake()) }}

with
    aggregated as (
        ({{ ec2_not_imdsv2_instances('imds_v2','EC2-IMDSv2') }})
        UNION
        ({{ lightsail_not_imdsv2_instances('imds_v2','Lightsail-IMDSv2') }})
        UNION
        ({{ images_imdsv2_required('imds_v2','AMIs-IMDSv2') }})
    )
select 
        ('{{ run_started_at }}')::timestamp as policy_execution_time,
        aggregated.*
from aggregated

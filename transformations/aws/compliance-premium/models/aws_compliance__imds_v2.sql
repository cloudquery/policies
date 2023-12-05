{{ config(enabled=block_bigquery() and block_snowflake()) }}

with
    aggregated as (
        ({{ ec2_not_imdsv2_instances('imds_v2','EC2-IMDSv2') }})
        {{ union() }}
        ({{ lightsail_not_imdsv2_instances('imds_v2','Lightsail-IMDSv2') }})
        {{ union() }}
        ({{ images_imdsv2_required('imds_v2','AMIs-IMDSv2') }})
    )
select 
        {{ gen_timestamp() }},
        aggregated.*
from aggregated

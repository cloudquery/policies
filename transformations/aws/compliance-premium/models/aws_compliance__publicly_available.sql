{{ config(enabled=block_bigquery() and block_snowflake()) }}

with
    aggregated as (
        ({{ api_gw_publicly_accessible('publicly_available','API-Gateways') }})
        {{ union() }}
        ({{ api_gw_v2_publicly_accessible('publicly_available','API-Gateway-V2') }})
        {{ union() }}
        ({{ all_distributions('publicly_available','CloudFront-Distributions') }})
        {{ union() }}
        ({{ public_ips('publicly_available','EC2-Public-Ips') }})
        {{ union() }}
        ({{ elbv1_internet_facing('publicly_available','ELB-Classic') }})
        {{ union() }}
        ({{ elbv2_internet_facing('publicly_available','ELB-V2') }})
        {{ union() }}
        ({{ cluster_publicly_accessible('publicly_available','Redshift') }})
        {{ union() }}
        ({{ rds_db_instances_should_prohibit_public_access('publicly_available','RDS') }})    
)
select 
        {{ gen_timestamp() }},
        aggregated.*
from aggregated

{{ config(enabled=block_bigquery() and block_snowflake()) }}

with
    aggregated as (
        ({{ api_gw_publicly_accessible('publicly_available','API-Gateways') }})
        UNION
        ({{ api_gw_v2_publicly_accessible('publicly_available','API-Gateway-V2') }})
        UNION
        ({{ all_distributions('publicly_available','CloudFront-Distributions') }})
        UNION
        ({{ public_ips('publicly_available','EC2-Public-Ips') }})
        UNION
        ({{ elbv1_internet_facing('publicly_available','ELB-Classic') }})
        UNION
        ({{ elbv2_internet_facing('publicly_available','ELB-V2') }})
        UNION
        ({{ cluster_publicly_accessible('publicly_available','Redshift') }})
        UNION
        ({{ rds_db_instances_should_prohibit_public_access('publicly_available','RDS') }})    
)
select 
        ('{{ run_started_at }}')::timestamp as policy_execution_time,
        aggregated.*
from aggregated

with
    aggregated as (
({{under_utilized_ec2_instances_default()}})
{{union()}}
({{under_utilized_rds_clusters_and_instances_default()}})
{{union()}}
({{under_utilized_dynamodb_tables_default()}})
    )
select 
        {{ gen_timestamp() }},
        aggregated.*
from aggregated 
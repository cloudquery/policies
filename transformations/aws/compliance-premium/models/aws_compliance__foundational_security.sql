with
    aggregated as (
        ({{ access_logs_enabled('foundational_security','cloudfront.5') }})
        
        union
        ({{ access_point_path_should_not_be_root('foundational_security','efs.3') }})
        union
        ({{ account_level_public_access_blocks('foundational_security','s3.1') }})
        
    )
select 
        ('{{ run_started_at }}')::timestamp as policy_execution_time,
        aggregated.*
from aggregated

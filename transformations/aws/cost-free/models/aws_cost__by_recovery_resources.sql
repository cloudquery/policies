with
    aggregated as (
    ({{ recovery_rds_db_snapshots() }})
    {{ union() }}
    ({{ recovery_lightsail_instance_snapshots() }})
    {{ union() }}
    ({{ recovery_dynamodb_backups() }})
    {{ union() }}
    ({{ recovery_fsx_backups() }})

    )
select 
        {{ gen_timestamp() }},
        aggregated.*
from aggregated
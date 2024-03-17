with
    aggregated as (
    ({{ recovery_rds_db_snapshots() }})
    {{ union() }}
    ({{ recovery_rds_cluster_snapshots() }})
    {{ union() }}
    ({{ recovery_docdb_cluster_snapshots() }})
    {{ union() }}
    ({{ recovery_elasticache_snapshots() }})
    {{ union() }}
    ({{ recovery_neptune_cluster_snapshots() }})
    {{ union() }}
    ({{ recovery_fsx_snapshots() }})
    {{ union() }}
    ({{ recovery_ec2_ebs_snapshots() }})
    {{ union() }}
    ({{ recovery_redshift_snapshots() }})
    {{ union() }}
    ({{ recovery_lightsail_instance_snapshots() }})
    {{ union() }}
    ({{ recovery_lightsail_disk_snapshots() }})
    {{ union() }}
    ({{ recovery_lightsail_database_snapshots() }})
    {{ union() }}
    ({{ recovery_cloudhsmv2_backups() }})
    {{ union() }}
    ({{ recovery_dynamodb_table_continuous_backups() }})
    {{ union() }}
    ({{ recovery_dynamodb_backups() }})
    {{ union() }}
    ({{ recovery_fsx_backups() }})

    )
select 
        {{ gen_timestamp() }},
        aggregated.*
from aggregated
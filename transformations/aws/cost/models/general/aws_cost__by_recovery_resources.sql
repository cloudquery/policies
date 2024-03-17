with
    aggregated as (
    ({{ recovery_rds_db_snapshots_cur_2() }})
    {{ union() }}
    ({{ recovery_rds_cluster_snapshots_cur_2() }})
    {{ union() }}
    ({{ recovery_docdb_cluster_snapshots_cur_2() }})
    {{ union() }}
    ({{ recovery_elasticache_snapshots_cur_2() }})
    {{ union() }}
    ({{ recovery_neptune_cluster_snapshots_cur_2() }})
    {{ union() }}
    ({{ recovery_fsx_snapshots_cur_2() }})
    {{ union() }}
    ({{ recovery_ec2_ebs_snapshots_cur_2() }})
    {{ union() }}
    ({{ recovery_redshift_snapshots_cur_2() }})
    {{ union() }}
    ({{ recovery_lightsail_instance_snapshots_cur_2() }})
    {{ union() }}
    ({{ recovery_lightsail_disk_snapshots_cur_2() }})
    {{ union() }}
    ({{ recovery_lightsail_database_snapshots_cur_2() }})
    {{ union() }}
    ({{ recovery_cloudhsmv2_backups_cur_2() }})
    {{ union() }}
    ({{ recovery_dynamodb_table_continuous_backups_cur_2() }})
    {{ union() }}
    ({{ recovery_dynamodb_backups_cur_2() }})
    {{ union() }}
    ({{ recovery_fsx_backups_cur_2() }})

    )
select 
        {{ gen_timestamp() }},
        aggregated.*
from aggregated
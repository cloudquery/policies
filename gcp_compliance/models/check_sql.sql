with
    aggregated as (
        {{ sql_mysql_skip_show_database_flag_off('cis_v1.2.0', '6.1.2') }}
        union
        {{ sql_mysql_local_inline_flag_on('cis_v1.2.0', '6.1.3') }}
        union
        {{ sql_postgresql_log_checkpoints_flag_off('cis_v1.2.0', '6.2.1') }}
        union
        {{ sql_postgresql_log_error_verbosity_flag_not_strict('cis_v1.2.0', '6.2.2') }}
        union
        {{ sql_postgresql_log_connections_flag_off('cis_v1.2.0', '6.2.3') }}
        union
        {{ sql_postgresql_log_disconnections_flag_off('cis_v1.2.0', '6.2.4') }}
        union
        {{ sql_postgresql_log_duration_flag_off('cis_v1.2.0', '6.2.5') }}
        union
        {{ sql_postgresql_log_lock_waits_flag_off('cis_v1.2.0', '6.2.6') }}
        union
        {{ sql_postgresql_log_hostname_flag_off('cis_v1.2.0', '6.2.8') }}
        union
        {{ sql_postgresql_log_parser_stats_flag_on('cis_v1.2.0', '6.2.9') }}
        union
        {{ sql_postgresql_log_planner_stats_flag_on('cis_v1.2.0', '6.2.10') }}
        union
        {{ sql_postgresql_log_executor_stats_flag_on('cis_v1.2.0', '6.2.11') }}
        union
        {{ sql_postgresql_log_statement_stats_flag_on('cis_v1.2.0', '6.2.12') }}
        union
        {{ sql_postgresql_log_min_error_statement_flag_less_error('cis_v1.2.0', '6.2.14') }}
        union
        {{ sql_postgresql_log_temp_files_flag_off('cis_v1.2.0', '6.2.15') }}
        union
        {{ sql_postgresql_log_min_duration_statement_flag_on('cis_v1.2.0', '6.2.16') }}
        union
        {{ sql_sqlserver_external_scripts_enabled_flag_on('cis_v1.2.0', '6.3.1') }}
        union
        {{ sql_sqlserver_cross_db_ownership_chaining_flag_on('cis_v1.2.0', '6.3.2') }}
        union
        {{ sql_sqlserver_user_connections_flag_not_set('cis_v1.2.0', '6.3.3') }}
        union
        {{ sql_sqlserver_user_options_flag_set('cis_v1.2.0', '6.3.4') }}
        union
        {{ sql_sqlserver_remote_access_flag_on('cis_v1.2.0', '6.3.5') }}
        union
        {{ sql_sqlserver_trace_flag_on('cis_v1.2.0', '6.3.6') }}
        union
        {{ sql_sqlserver_contained_database_authentication_flag_on('cis_v1.2.0', '6.3.7') }}
        union
        {{ sql_db_instance_without_ssl('cis_v1.2.0', '6.4') }}
        union
        {{ sql_db_instance_publicly_accessible('cis_v1.2.0', '6.5') }}
        union
        {{ sql_db_instance_with_public_ip('cis_v1.2.0', '6.6') }}
        union
        {{ sql_db_instances_without_backups('cis_v1.2.0', '6.7') }}
    )

select *
from aggregated

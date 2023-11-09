with
    aggregated as (
        ({{ iam_managed_service_account_keys('cis_v1.2.0', '1.4') }})
        union
        ({{ iam_service_account_admin_priv('cis_v1.2.0', '1.5') }})
        union
        ({{ iam_users_with_service_account_token_creator_role('cis_v1.2.0', '1.6') }})
        union
        ({{ iam_service_account_keys_not_rotated('cis_v1.2.0', '1.7') }})
        union
        ({{ iam_separation_of_duties('cis_v1.2.0', '1.8') }})
        union
        ({{ kms_publicly_accessible('cis_v1.2.0', '1.9') }})
        union
        ({{ kms_keys_not_rotated_within_90_days('cis_v1.2.0', '1.10') }})
        union
        ({{ kms_separation_of_duties('cis_v1.2.0', '1.11') }})
        union
        ({{ logging_not_configured_across_services_and_users('cis_v1.2.0', '2.1') }})
        union
        ({{ logging_sinks_not_configured_for_all_log_entries('cis_v1.2.0', '2.2') }})
        union
        ({{ logging_log_buckets_retention_policy_disabled('cis_v1.2.0', '2.3') }})
        union
        ({{ logging_project_ownership_changes_without_log_metric_filter_alerts('cis_v1.2.0', '2.4') }})
        union
        ({{ logging_audit_config_changes_without_log_metric_filter_alerts('cis_v1.2.0', '2.5') }})
        union
        ({{ logging_custom_role_changes_without_log_metric_filter_alerts('cis_v1.2.0', '2.6') }})
        union
        ({{ logging_vpc_firewall_changes_without_log_metric_filter_alerts('cis_v1.2.0', '2.7') }})
        union
        ({{ logging_vpc_route_changes_without_log_metric_filter_alerts('cis_v1.2.0', '2.8') }})
        union
        ({{ logging_vpc_network_changes_without_log_metric_filter_alerts('cis_v1.2.0', '2.9') }})
        union
        ({{ logging_storage_iam_changes_without_log_metric_filter_alerts('cis_v1.2.0', '2.10') }})
        union
        ({{ logging_sql_instance_changes_without_log_metric_filter_alerts('cis_v1.2.0', '2.11') }})
        union
        ({{ logging_dns_logging_disabled('cis_v1.2.0', '2.12') }})
        union
        ({{ compute_default_network_exist('cis_v1.2.0', '3.1') }})
        union
        ({{ compute_legacy_network_exist('cis_v1.2.0', '3.2') }})
        union
        ({{ dns_zones_with_dnssec_disabled('cis_v1.2.0', '3.3') }})
        union
        ({{ dns_key_signing_with_rsasha1('cis_v1.2.0', '3.4') }})
        union
        ({{ dns_zone_signing_with_rsasha1('cis_v1.2.0', '3.5') }})
        union
        ({{ compute_ssh_access_permitted('cis_v1.2.0', '3.6') }})
        union
        ({{ compute_rdp_access_permitted('cis_v1.2.0', '3.7') }})
        union
        ({{ compute_flow_logs_disabled_in_vpc('cis_v1.2.0', '3.8') }})
        union
        ({{ compute_ssl_proxy_with_weak_cipher('cis_v1.2.0', '3.9') }})
        union
        ({{ compute_allow_traffic_behind_iap('cis_v1.2.0', '3.10') }})
        union
        ({{ compute_instances_with_default_service_account('cis_v1.2.0', '4.1') }})
        union
        ({{ compute_instances_with_default_service_account_with_full_access('cis_v1.2.0', '4.2') }})
        union
        ({{ compute_instances_without_block_project_wide_ssh_keys('cis_v1.2.0', '4.3') }})
        union
        ({{ compute_oslogin_disabled('cis_v1.2.0', '4.4') }})
        union
        ({{ compute_serial_port_connection_enabled('cis_v1.2.0', '4.5') }})
        union
        ({{ compute_disks_encrypted_with_csek('cis_v1.2.0', '4.7') }})
        union
        ({{ compute_instances_with_shielded_vm_disabled('cis_v1.2.0', '4.8') }})
        union
        ({{ compute_instances_with_public_ip('cis_v1.2.0', '4.9') }})
        union
        ({{ compute_instances_without_confidential_computing('cis_v1.2.0', '4.11') }})
        union
        ({{ storage_buckets_publicly_accessible('cis_v1.2.0', '5.1') }})
        union
        ({{ storage_buckets_without_uniform_bucket_level_access('cis_v1.2.0', '5.2') }})
        union
        ({{ sql_mysql_skip_show_database_flag_off('cis_v1.2.0', '6.1.2') }})
        union
        ({{ sql_mysql_local_inline_flag_on('cis_v1.2.0', '6.1.3') }})
        union
        ({{ sql_postgresql_log_checkpoints_flag_off('cis_v1.2.0', '6.2.1') }})
        union
        ({{ sql_postgresql_log_error_verbosity_flag_not_strict('cis_v1.2.0', '6.2.2') }})
        union
        ({{ sql_postgresql_log_connections_flag_off('cis_v1.2.0', '6.2.3') }})
        union
        ({{ sql_postgresql_log_disconnections_flag_off('cis_v1.2.0', '6.2.4') }})
        union
        ({{ sql_postgresql_log_duration_flag_off('cis_v1.2.0', '6.2.5') }})
        union
        ({{ sql_postgresql_log_lock_waits_flag_off('cis_v1.2.0', '6.2.6') }})
        union
        ({{ sql_postgresql_log_hostname_flag_off('cis_v1.2.0', '6.2.8') }})
        union
        ({{ sql_postgresql_log_parser_stats_flag_on('cis_v1.2.0', '6.2.9') }})
        union
        ({{ sql_postgresql_log_planner_stats_flag_on('cis_v1.2.0', '6.2.10') }})
        union
        ({{ sql_postgresql_log_executor_stats_flag_on('cis_v1.2.0', '6.2.11') }})
        union
        ({{ sql_postgresql_log_statement_stats_flag_on('cis_v1.2.0', '6.2.12') }})
        union
        ({{ sql_postgresql_log_min_error_statement_flag_less_error('cis_v1.2.0', '6.2.14') }})
        union
        ({{ sql_postgresql_log_temp_files_flag_off('cis_v1.2.0', '6.2.15') }})
        union
        ({{ sql_postgresql_log_min_duration_statement_flag_on('cis_v1.2.0', '6.2.16') }})
        union
        ({{ sql_sqlserver_external_scripts_enabled_flag_on('cis_v1.2.0', '6.3.1') }})
        union
        ({{ sql_sqlserver_cross_db_ownership_chaining_flag_on('cis_v1.2.0', '6.3.2') }})
        union
        ({{ sql_sqlserver_user_connections_flag_not_set('cis_v1.2.0', '6.3.3') }})
        union
        ({{ sql_sqlserver_user_options_flag_set('cis_v1.2.0', '6.3.4') }})
        union
        ({{ sql_sqlserver_remote_access_flag_on('cis_v1.2.0', '6.3.5') }})
        union
        ({{ sql_sqlserver_trace_flag_on('cis_v1.2.0', '6.3.6') }})
        union
        ({{ sql_sqlserver_contained_database_authentication_flag_on('cis_v1.2.0', '6.3.7') }})
        union
        ({{ sql_db_instance_without_ssl('cis_v1.2.0', '6.4') }})
        union
        ({{ sql_db_instance_publicly_accessible('cis_v1.2.0', '6.5') }})
        union
        ({{ sql_db_instance_with_public_ip('cis_v1.2.0', '6.6') }})
        union
        ({{ sql_db_instances_without_backups('cis_v1.2.0', '6.7') }})
        union
        ({{ bigquery_datasets_publicly_accessible('cis_v1.2.0', '7.1') }})
        union
        ({{ bigquery_datasets_without_default_cmek('cis_v1.2.0', '7.2') }})
        union
        ({{ bigquery_tables_not_encrypted_with_cmek('cis_v1.2.0', '7.3') }})
    )
select *
from aggregated

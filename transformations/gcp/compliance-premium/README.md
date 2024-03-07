# CloudQuery &times; dbt: GCP Compliance Package

## Overview

### Requirements

- [dbt](https://docs.getdbt.com/docs/installation)
- [CloudQuery](https://www.cloudquery.io/docs/quickstart)

One of the below databases

- [PostgreSQL](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql)
- [Snowflake](https://hub.cloudquery.io/plugins/destination/cloudquery/snowflake)
- [BigQuery](https://hub.cloudquery.io/plugins/destination/cloudquery/bigquery)

### What's in the pack

- [DBT + Snowflake](https://docs.getdbt.com/docs/core/connect-data-platform/snowflake-setup)
- [DBT + Postgres](https://docs.getdbt.com/docs/core/connect-data-platform/postgres-setup)
- [DBT + BigQuery](https://docs.getdbt.com/docs/core/connect-data-platform/bigquery-setup)

An example of how to install dbt to work with the destination of your choice.

First, install `dbt` for the destination of your choice:

The pack contains the premium version.
The premium version contains all queries.

#### Models

- **gcp_compliance\_\_cis_v1.2.0**: GCP CIS V1.2.0 benchmarks, available for PostgreSQL

#### Running Your dbt Project

Navigate to your dbt project directory, where your `dbt_project.yml` resides.

Before executing the `dbt run` command, it might be useful to check for any potential issues:

```bash
dbt compile
```

If everything compiles without errors, you can then execute:

```bash
dbt run
```

This command will run your `dbt` models and create tables/views in your destination database as defined in your models.

To run specific models and the models in the dependency graph, the following `dbt run` commands can be used:

For a specific model and the models in the dependency graph:

```bash
dbt run --select +"<model_name>"
```

For a specific folder and the models in the dependency graph:

```bash
dbt run --models +pro
```

More information can be found [here.](https://docs.getdbt.com/reference/node-selection/syntax)

### Usage

- Sync your data from GCP to destination (Postgres Example): `cloudquery sync gcp.yml postgres.yml`

- Run dbt: `dbt run`

<!-- AUTO-GENERATED-INCLUDED-CHECKS-START -->
#### Included Checks

##### `cis_v1.2.0`

- ✅ `1.4`: `iam_managed_service_account_keys`
- ✅ `1.5`: `iam_service_account_admin_priv`
- ✅ `1.6`: `iam_users_with_service_account_token_creator_role`
- ✅ `1.7`: `iam_service_account_keys_not_rotated`
- ✅ `1.8`: `iam_separation_of_duties`
- ✅ `1.9`: `kms_publicly_accessible`
- ✅ `1.10`: `kms_keys_not_rotated_within_90_days`
- ✅ `1.11`: `kms_separation_of_duties`
- ✅ `2.1`: `logging_not_configured_across_services_and_users`
- ✅ `2.2`: `logging_sinks_not_configured_for_all_log_entries`
- ✅ `2.3`: `logging_log_buckets_retention_policy_disabled`
- ✅ `2.4`: `logging_project_ownership_changes_without_log_metric_filter_alerts`
- ✅ `2.5`: `logging_audit_config_changes_without_log_metric_filter_alerts`
- ✅ `2.6`: `logging_custom_role_changes_without_log_metric_filter_alerts`
- ✅ `2.7`: `logging_vpc_firewall_changes_without_log_metric_filter_alerts`
- ✅ `2.8`: `logging_vpc_route_changes_without_log_metric_filter_alerts`
- ✅ `2.9`: `logging_vpc_network_changes_without_log_metric_filter_alerts`
- ✅ `2.10`: `logging_storage_iam_changes_without_log_metric_filter_alerts`
- ✅ `2.11`: `logging_sql_instance_changes_without_log_metric_filter_alerts`
- ✅ `2.12`: `logging_dns_logging_disabled`
- ✅ `3.1`: `compute_default_network_exist`
- ✅ `3.2`: `compute_legacy_network_exist`
- ✅ `3.3`: `dns_zones_with_dnssec_disabled`
- ✅ `3.4`: `dns_key_signing_with_rsasha1`
- ✅ `3.5`: `dns_zone_signing_with_rsasha1`
- ✅ `3.6`: `compute_ssh_access_permitted`
- ✅ `3.7`: `compute_rdp_access_permitted`
- ✅ `3.8`: `compute_flow_logs_disabled_in_vpc`
- ✅ `3.9`: `compute_ssl_proxy_with_weak_cipher`
- ✅ `3.10`: `compute_allow_traffic_behind_iap`
- ✅ `4.1`: `compute_instances_with_default_service_account`
- ✅ `4.2`: `compute_instances_with_default_service_account_with_full_access`
- ✅ `4.3`: `compute_instances_without_block_project_wide_ssh_keys`
- ✅ `4.4`: `compute_oslogin_disabled`
- ✅ `4.5`: `compute_serial_port_connection_enabled`
- ✅ `4.7`: `compute_disks_encrypted_with_csek`
- ✅ `4.8`: `compute_instances_with_shielded_vm_disabled`
- ✅ `4.9`: `compute_instances_with_public_ip`
- ✅ `4.11`: `compute_instances_without_confidential_computing`
- ✅ `5.1`: `storage_buckets_publicly_accessible`
- ✅ `5.2`: `storage_buckets_without_uniform_bucket_level_access`
- ✅ `6.1.2`: `sql_mysql_skip_show_database_flag_off`
- ✅ `6.1.3`: `sql_mysql_local_inline_flag_on`
- ✅ `6.2.1`: `sql_postgresql_log_checkpoints_flag_off`
- ✅ `6.2.2`: `sql_postgresql_log_error_verbosity_flag_not_strict`
- ✅ `6.2.3`: `sql_postgresql_log_connections_flag_off`
- ✅ `6.2.4`: `sql_postgresql_log_disconnections_flag_off`
- ✅ `6.2.5`: `sql_postgresql_log_duration_flag_off`
- ✅ `6.2.6`: `sql_postgresql_log_lock_waits_flag_off`
- ✅ `6.2.8`: `sql_postgresql_log_hostname_flag_off`
- ✅ `6.2.9`: `sql_postgresql_log_parser_stats_flag_on`
- ✅ `6.2.10`: `sql_postgresql_log_planner_stats_flag_on`
- ✅ `6.2.11`: `sql_postgresql_log_executor_stats_flag_on`
- ✅ `6.2.12`: `sql_postgresql_log_statement_stats_flag_on`
- ✅ `6.2.14`: `sql_postgresql_log_min_error_statement_flag_less_error`
- ✅ `6.2.15`: `sql_postgresql_log_temp_files_flag_off`
- ✅ `6.2.16`: `sql_postgresql_log_min_duration_statement_flag_on`
- ✅ `6.3.1`: `sql_sqlserver_external_scripts_enabled_flag_on`
- ✅ `6.3.2`: `sql_sqlserver_cross_db_ownership_chaining_flag_on`
- ✅ `6.3.3`: `sql_sqlserver_user_connections_flag_not_set`
- ✅ `6.3.4`: `sql_sqlserver_user_options_flag_set`
- ✅ `6.3.5`: `sql_sqlserver_remote_access_flag_on`
- ✅ `6.3.6`: `sql_sqlserver_trace_flag_on`
- ✅ `6.3.7`: `sql_sqlserver_contained_database_authentication_flag_on`
- ✅ `6.4`: `sql_db_instance_without_ssl`
- ✅ `6.5`: `sql_db_instance_publicly_accessible`
- ✅ `6.6`: `sql_db_instance_with_public_ip`
- ✅ `6.7`: `sql_db_instances_without_backups`
- ✅ `7.1`: `bigquery_datasets_publicly_accessible`
- ✅ `7.2`: `bigquery_datasets_without_default_cmek`
- ✅ `7.3`: `bigquery_tables_not_encrypted_with_cmek`

##### `cis_v2.0.0`

- ✅ `1.4`: `iam_managed_service_account_keys`
- ✅ `1.5`: `iam_service_account_admin_priv`
- ✅ `1.6`: `iam_users_with_service_account_token_creator_role`
- ✅ `1.7`: `iam_service_account_keys_not_rotated`
- ✅ `1.8`: `iam_separation_of_duties`
- ✅ `1.9`: `kms_publicly_accessible`
- ✅ `1.10`: `kms_keys_not_rotated_within_90_days`
- ✅ `1.11`: `kms_separation_of_duties`
- ✅ `1.12`: `iam_ensure_no_api_keys`
- ✅ `1.13`: `iam_api_keys_restricted`
- ✅ `1.14`: `iam_application_api_keys_restricted`
- ✅ `1.15`: `iam_api_keys_rotated`
- ✅ `1.16`: `iam_essential_contacts_configured`
- ✅ `1.17`: `iam_dataproc_clusters_encrypted_with_cmk`
- ✅ `2.1`: `logging_not_configured_across_services_and_users`
- ✅ `2.2`: `logging_sinks_not_configured_for_all_log_entries`
- ✅ `2.3`: `logging_log_buckets_retention_policy_disabled`
- ✅ `2.4`: `logging_project_ownership_changes_without_log_metric_filter_alerts`
- ✅ `2.5`: `logging_audit_config_changes_without_log_metric_filter_alerts`
- ✅ `2.6`: `logging_custom_role_changes_without_log_metric_filter_alerts`
- ✅ `2.7`: `logging_vpc_firewall_changes_without_log_metric_filter_alerts`
- ✅ `2.8`: `logging_vpc_route_changes_without_log_metric_filter_alerts`
- ✅ `2.9`: `logging_vpc_network_changes_without_log_metric_filter_alerts`
- ✅ `2.10`: `logging_storage_iam_changes_without_log_metric_filter_alerts`
- ✅ `2.11`: `logging_sql_instance_changes_without_log_metric_filter_alerts`
- ✅ `2.12`: `logging_dns_logging_disabled`
- ✅ `2.13`: `logging_cloud_asset_inventory_enabled`
- ✅ `2.15`: `logging_access_approval_enabled`
- ✅ `2.16`: `logging_enabled_for_load_balancers`
- ✅ `3.1`: `compute_default_network_exist`
- ✅ `3.2`: `compute_legacy_network_exist`
- ✅ `3.3`: `dns_zones_with_dnssec_disabled`
- ✅ `3.4`: `dns_key_signing_with_rsasha1`
- ✅ `3.5`: `dns_zone_signing_with_rsasha1`
- ✅ `3.6`: `compute_ssh_access_permitted`
- ✅ `3.7`: `compute_rdp_access_permitted`
- ✅ `3.8`: `compute_flow_logs_disabled_in_vpc`
- ✅ `3.9`: `compute_ssl_proxy_with_weak_cipher`
- ✅ `3.10`: `compute_allow_traffic_behind_iap`
- ✅ `4.1`: `compute_instances_with_default_service_account`
- ✅ `4.2`: `compute_instances_with_default_service_account_with_full_access`
- ✅ `4.3`: `compute_instances_without_block_project_wide_ssh_keys`
- ✅ `4.4`: `compute_oslogin_disabled`
- ✅ `4.5`: `compute_serial_port_connection_enabled`
- ✅ `4.7`: `compute_disks_encrypted_with_csek`
- ✅ `4.8`: `compute_instances_with_shielded_vm_disabled`
- ✅ `4.9`: `compute_instances_with_public_ip`
- ✅ `4.11`: `compute_instances_without_confidential_computing`
- ✅ `5.1`: `storage_buckets_publicly_accessible`
- ✅ `5.2`: `storage_buckets_without_uniform_bucket_level_access`
- ✅ `6.1.2`: `sql_mysql_skip_show_database_flag_off`
- ✅ `6.1.3`: `sql_mysql_local_inline_flag_on`
- ✅ `6.2.1`: `sql_postgresql_log_checkpoints_flag_off`
- ✅ `6.2.2`: `sql_postgresql_log_error_verbosity_flag_not_strict`
- ✅ `6.2.3`: `sql_postgresql_log_connections_flag_off`
- ✅ `6.2.4`: `sql_postgresql_log_disconnections_flag_off`
- ✅ `6.2.5`: `sql_postgresql_log_duration_flag_off`
- ✅ `6.2.6`: `sql_postgresql_log_lock_waits_flag_off`
- ✅ `6.2.8`: `sql_postgresql_log_hostname_flag_off`
- ✅ `6.2.9`: `sql_postgresql_log_parser_stats_flag_on`
- ✅ `6.2.10`: `sql_postgresql_log_planner_stats_flag_on`
- ✅ `6.2.11`: `sql_postgresql_log_executor_stats_flag_on`
- ✅ `6.2.12`: `sql_postgresql_log_statement_stats_flag_on`
- ✅ `6.2.14`: `sql_postgresql_log_min_error_statement_flag_less_error`
- ✅ `6.2.15`: `sql_postgresql_log_temp_files_flag_off`
- ✅ `6.2.16`: `sql_postgresql_log_min_duration_statement_flag_on`
- ✅ `6.3.1`: `sql_sqlserver_external_scripts_enabled_flag_on`
- ✅ `6.3.2`: `sql_sqlserver_cross_db_ownership_chaining_flag_on`
- ✅ `6.3.3`: `sql_sqlserver_user_connections_flag_not_set`
- ✅ `6.3.4`: `sql_sqlserver_user_options_flag_set`
- ✅ `6.3.5`: `sql_sqlserver_remote_access_flag_on`
- ✅ `6.3.6`: `sql_sqlserver_trace_flag_on`
- ✅ `6.3.7`: `sql_sqlserver_contained_database_authentication_flag_on`
- ✅ `6.4`: `sql_db_instance_without_ssl`
- ✅ `6.5`: `sql_db_instance_publicly_accessible`
- ✅ `6.6`: `sql_db_instance_with_public_ip`
- ✅ `6.7`: `sql_db_instances_without_backups`
- ✅ `7.1`: `bigquery_datasets_publicly_accessible`
- ✅ `7.2`: `bigquery_datasets_without_default_cmek`
- ✅ `7.3`: `bigquery_tables_not_encrypted_with_cmek`
<!-- AUTO-GENERATED-INCLUDED-CHECKS-END -->
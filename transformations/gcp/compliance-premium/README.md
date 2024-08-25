# CloudQuery &times; dbt: GCP Compliance Package

## Overview

Welcome to GCP Compliance Package, a compliance solution that works on top of the CloudQuery framework. This package offers automated checks across various GCP services, following benchmarks such as CIS 1.2 and CIS 2.0.
Using this solution you can get instant insights about your security posture and make sure you are following the recommended security guidelines defined by CIS.

### Examples

How many checks failed in the CIS 2.0 benchmark? (PostgreSQL)
```sql
SELECT count(*) as failed_count
FROM gcp_compliance__cis_v2_0_0
WHERE status = 'fail'
```

Which resource failed the most tests in the CIS 1.2 benchmark? (PostgreSQL)
```sql
SELECT resource_id, count(*) as failed_count
FROM gcp_compliance__cis_v1_2_0
WHERE status = 'fail'
GROUP BY resource_id
ORDER BY count(*) DESC
```

### Requirements

- [dbt](https://docs.getdbt.com/docs/core/pip-install)
- [CloudQuery](https://www.cloudquery.io/docs/quickstart)
- [A CloudQuery Account](https://www.cloudquery.io/auth/register)
- [GCP Source Plugin](https://hub.cloudquery.io/plugins/source/cloudquery/gcp/latest/docs)

One of the below databases

- [PostgreSQL](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql)
- [Snowflake](https://hub.cloudquery.io/plugins/destination/cloudquery/snowflake)
- [BigQuery](https://hub.cloudquery.io/plugins/destination/cloudquery/bigquery)

### What's in the pack

Automated compliance checks following CIS 1.2 and 2.0

## To run this package you need to complete the following steps

### Setting up the DBT profile (PostgreSQL)
First, [install `dbt`](https://docs.getdbt.com/docs/core/pip-install):
```bash
pip install dbt-postgres
```

Create the profile directory:

```bash
mkdir -p ~/.dbt
```

Create a `profiles.yml` file in your profile directory (e.g. `~/.dbt/profiles.yml`):

```yaml
gcp_compliance: # This should match the name in your dbt_project.yml
  target: dev
  outputs:
    dev:
      type: postgres
      host: 127.0.0.1
      user: postgres
      pass: pass
      port: 5432
      dbname: postgres
      schema: public # default schema where dbt will build the models
      threads: 1 # number of threads to use when running in parallel
```

Test the Connection:

After setting up your `profiles.yml`, you should test the connection to ensure everything is configured correctly:

```bash
dbt debug
```

This command will tell you if dbt can successfully connect to your PostgreSQL instance.

### Login to CloudQuery
Because this policy uses premium features and tables you must login to your cloudquery account using
`cloudquery login` in your terminal.

### Syncing GCP data
Based on the models you are interested in running, you need to sync the relevant tables.
this is an example sync for the relevant tables for all the models (views) in the policy and with the PostgreSQL destination. This package also supports Snowflake and Google BigQuery

 ```yml
kind: source
spec:
  name: gcp # The source type, in this case, GCP.
  path: cloudquery/gcp # The plugin path for handling GCP sources.
  registry: cloudquery # The registry from which the GCP plugin is sourced.
  version: "12.3.2" # The version of the GCP plugin.
  tables: ["gcp_dns_policies","gcp_accessapproval_project_settings","gcp_sql_instances","gcp_storage_buckets","gcp_compute_backend_services","gcp_iam_service_account_keys","gcp_compute_disks","gcp_compute_instances","gcp_dataproc_clusters","gcp_logging_metrics","gcp_bigquery_datasets","gcp_compute_subnetworks","gcp_essentialcontacts_folder_contacts","gcp_resourcemanager_project_policies","gcp_iam_service_accounts","gcp_logging_sinks","gcp_compute_projects","gcp_accessapproval_folder_settings","gcp_essentialcontacts_project_contacts","gcp_compute_ssl_policies","gcp_compute_target_ssl_proxies","gcp_compute_url_maps","gcp_accessapproval_organization_settings","gcp_compute_firewalls","gcp_dns_managed_zones","gcp_storage_bucket_policies","gcp_apikeys_keys","gcp_kms_crypto_keys","gcp_bigquery_tables","gcp_compute_networks","gcp_essentialcontacts_organization_contacts","gcp_serviceusage_services"]
  destinations: ["postgresql"] # The destination for the data, in this case, PostgreSQL.
  spec:

---
kind: destination
spec:
  name: "postgresql" # The type of destination, in this case, PostgreSQL.
  path: "cloudquery/postgresql" # The plugin path for handling PostgreSQL as a destination.
  registry: "cloudquery" # The registry from which the PostgreSQL plugin is sourced.
  version: "v8.0.1" # The version of the PostgreSQL plugin.

  spec:
    connection_string: "${POSTGRESQL_CONNECTION_STRING}"  # set the environment variable in a format like 
    # postgresql://postgres:pass@localhost:5432/postgres?sslmode=disable
    # You can also specify the connection string in DSN format, which allows for special characters in the password:
    # connection_string: "user=postgres password=pass+0-[word host=localhost port=5432 dbname=postgres"

 ```

 See [Hub](https://hub.cloudquery.io) to browse individual plugins and to get their detailed documentation.


## Pre-Run Table Existence Check in Your dbt Project

Before executing models in your dbt project, it's a good practice to ensure that all necessary tables are available in your database. This step prevents failures during model execution due to missing tables. 

### Run the Table Check Operation

To verify the existence of required tables for specific models, use the `run-operation` command provided by dbt. This command invokes a custom operation (macro) that checks for the presence of necessary tables in the database.

**Command to Check Table Existence**:
```bash
dbt run-operation check_tables_exist --args '{"variable_name": "variable_name_here"}'
```

### Variable Names You Can Use
Each variable name corresponds to a specific model or a set of models within your dbt project. Use one of the following variable names as needed:

- **cis_v1_2_0**
- **cis_v2_0_0**
- **gcp_models**

### Running Your dbt Project

Navigate to your dbt project directory, where your `dbt_project.yml` resides. Make sure to have an existing profile in your `profiles.yml` that contains your PostgreSQL/Snowflake/BigQuery connection and authentication information.

If everything compiles without errors, you can then execute:

```bash
dbt run
```

This command will run all your `dbt` models and create tables/views in your destination database as defined in your models.

**Note:** If running locally, ensure you are using `dbt-core` and not `dbt-cloud-cli` as dbt-core does not require extra authentication.

## Running Specific Models in dbt

To execute a specific model along with its dependencies in your dbt project, use the `--select` option with the `dbt run` command. This command ensures that all dependencies for the specified model are also executed.

```bash
dbt run --select +<model_name>
```

### Models

The following models are available for PostgreSQL, Snowflake and Google BigQuery.
- **gcp_compliance\_\_cis_v1_2_0.sql**: GCP Compliance CIS V1.3.0.
- **gcp_compliance\_\_cis_v2_0_0.sql**: GCP Compliance CIS V2.0.0.

The premium version contains all queries.

All of the models contain the following columns:
- **framework**: The benchmark the check belongs to.
- **check_id**: The check identifier (either a number or the service name and number).
- **title**: The name/title of the check.
- **resource_id**: The gcp resource id.
- **project_id**: The gcp project id.
- **status**: The status of the check (fail / pass).


### Required tables
- **gcp_compliance\_\_cis_v1_2_0.sql**:
```yaml
tables: ["gcp_dns_policies",
"gcp_sql_instances",
"gcp_resourcemanager_project_policies",
"gcp_iam_service_accounts",
"gcp_iam_service_account_keys",
"gcp_compute_disks",
"gcp_bigquery_datasets",
"gcp_compute_subnetworks",
"gcp_compute_ssl_policies",
"gcp_storage_bucket_policies",
"gcp_kms_crypto_keys",
"gcp_bigquery_tables",
"gcp_compute_firewalls",
"gcp_compute_networks",
"gcp_storage_buckets",
"gcp_compute_instances",
"gcp_logging_metrics",
"gcp_logging_sinks",
"gcp_compute_projects",
"gcp_compute_target_ssl_proxies",
"gcp_dns_managed_zones"]
```
- **gcp_compliance\_\_cis_v2_0_0.sql**:
```yaml
tables: ["gcp_dns_policies",
"gcp_accessapproval_project_settings",
"gcp_sql_instances",
"gcp_resourcemanager_project_policies",
"gcp_iam_service_accounts",
"gcp_iam_service_account_keys",
"gcp_compute_disks",
"gcp_bigquery_datasets",
"gcp_compute_subnetworks",
"gcp_accessapproval_folder_settings",
"gcp_compute_ssl_policies",
"gcp_compute_url_maps",
"gcp_storage_bucket_policies",
"gcp_apikeys_keys",
"gcp_kms_crypto_keys",
"gcp_bigquery_tables",
"gcp_serviceusage_services",
"gcp_compute_backend_services",
"gcp_essentialcontacts_project_contacts",
"gcp_compute_firewalls",
"gcp_compute_networks",
"gcp_storage_buckets",
"gcp_compute_instances",
"gcp_dataproc_clusters",
"gcp_logging_metrics",
"gcp_essentialcontacts_folder_contacts",
"gcp_logging_sinks",
"gcp_compute_projects",
"gcp_accessapproval_organization_settings",
"gcp_compute_target_ssl_proxies",
"gcp_dns_managed_zones",
"gcp_essentialcontacts_organization_contacts"]
```
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


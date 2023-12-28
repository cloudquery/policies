# CloudQuery &times; dbt: Azure Compliance Package

## Overview

This package contains dbt models (views) that gives compliance insights from CloudQuery [Azure plugin](https://hub.cloudquery.io/plugins/source/cloudquery/azure) data.


### Requirements

- [CloudQuery](https://www.cloudquery.io/docs/quickstart)
- [CloudQuery Azure plugin](https://hub.cloudquery.io/plugins/source/cloudquery/azure)
- [dbt](https://docs.getdbt.com/docs/installation)
 
One of the below databases:

- [PostgreSQL](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql)
- [Snowflake](https://hub.cloudquery.io/plugins/destination/cloudquery/snowflake)


#### dbt Installation

- [DBT + Snowflake](https://docs.getdbt.com/docs/core/connect-data-platform/snowflake-setup)
- [DBT + Postgres](https://docs.getdbt.com/docs/core/connect-data-platform/postgres-setup)
- [DBT + BigQuery](https://docs.getdbt.com/docs/core/connect-data-platform/bigquery-setup)

An example of how to install dbt to work with the destination of your choice.

First, install `dbt` for the destination of your choice:

An example installation of dbt-postgres:

```bash
pip install dbt-postgres
```

An example installation of dbt-snowflake:

```bash
pip install dbt-snowflake
```

These commands will also install install dbt-core and any other dependencies.

Create the profile directory:

```bash
mkdir -p ~/.dbt
```

Create a `profiles.yml` file in your profile directory (e.g. `~/.dbt/profiles.yml`):

```yaml
azure_compliance: # This should match the name in your dbt_project.yml
  target: dev
  outputs:
    dev:
      type: postgres
      host: 127.0.0.1
      user: postgres
      pass: pass
      port: 5432
      dbname: azure
      schema: public # default schema where dbt will build the models
      threads: 1 # number of threads to use when running in parallel
```

Test the Connection:

After setting up your `profiles.yml`, you should test the connection to ensure everything is configured correctly:

```bash
dbt debug
```

This command will tell you if dbt can successfully connect to your destination database.

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

### What's in the pack

The pack contains the premium version.

#### Models

- **azure_compliance\_\_cis_v1_3_0.sql**: Azure Compliance CIS V1.3.0, available for PostgreSQL and Snowflake.

The premium version contains all queries.

<!-- AUTO-GENERATED-INCLUDED-CHECKS-START -->
#### Included Checks

##### `cis_v1.3.0`

- ✅ `1.21`: `iam_custom_subscription_owner_roles`
- ✅ `2.1`: `security_defender_on_for_servers`
- ✅ `2.2`: `security_defender_on_for_app_service`
- ✅ `2.3`: `security_defender_on_for_sql_servers`
- ✅ `2.4`: `security_defender_on_for_sql_servers_on_machines`
- ✅ `2.5`: `security_defender_on_for_storage`
- ✅ `2.6`: `security_defender_on_for_k8s`
- ✅ `2.7`: `security_defender_on_for_container_registeries`
- ✅ `2.8`: `security_defender_on_for_key_vault`
- ✅ `2.11`: `security_auto_provisioning_monitoring_agent_enabled`
- ✅ `2.12`: `security_default_policy_disabled`
- ✅ `3.1`: `storage_secure_transfer_to_storage_accounts_should_be_enabled`
- ✅ `3.5`: `storage_no_public_blob_container`
- ✅ `3.6`: `storage_default_network_access_rule_is_deny`
- ✅ `3.8`: `storage_soft_delete_is_enabled`
- ✅ `3.9`: `storage_encrypt_with_cmk`
- ✅ `4.1.1`: `sql_auditing_off`
- ✅ `4.1.2`: `sql_data_encryption_off`
- ✅ `4.1.3`: `sql_auditing_retention_less_than_90_days`
- ✅ `4.2.1`: `sql_atp_on_sql_server_disabled`
- ✅ `4.2.2`: `sql_va_is_enabled_on_sql_server_by_storage_account`
- ✅ `4.2.3`: `sql_va_periodic_scans_enabled_on_sql_server`
- ✅ `4.2.4`: `sql_va_send_scan_report_enabled_on_sql_server`
- ✅ `4.2.5`: `sql_va_send_email_to_admins_and_owners_enabled`
- ✅ `4.3.1`: `sql_postgresql_ssl_enforcment_disabled`
- ✅ `4.3.2`: `sql_mysql_ssl_enforcment_disabled`
- ✅ `4.3.3`: `sql_postgresql_log_checkpoints_disabled`
- ✅ `4.3.4`: `sql_postgresql_log_connections_disabled`
- ✅ `4.3.5`: `sql_postgresql_log_disconnections_disabled`
- ✅ `4.3.6`: `sql_postgresql_connection_throttling_disabled`
- ✅ `4.3.7`: `sql_postgresql_log_retention_days_less_than_3_days`
- ✅ `4.3.8`: `sql_postgresql_allow_access_to_azure_services_enabled`
- ✅ `4.4`: `sql_ad_admin_configured`
- ✅ `4.5`: `sql_sqlserver_tde_not_encrypted_with_cmek`
- ✅ `5.1.1`: `monitor_no_diagnostic_setting`
- ✅ `5.1.2`: `monitor_insufficient_diagnostic_capturing_settings`
- ✅ `5.1.3`: `storage_no_publicly_accessible_insights_activity_logs`
- ✅ `5.1.4`: `storage_encrypt_with_cmk_for_activity_log`
- ✅ `5.1.5`: `monitor_logging_key_valut_is_enabled`
- ✅ `5.2.1`: `monitor_log_alert_for_create_policy_assignment`
- ✅ `5.2.2`: `monitor_log_alert_for_delete_policy_assignment`
- ✅ `5.2.3`: `monitor_log_alert_for_create_or_update_network_sg`
- ✅ `5.2.4`: `monitor_log_alert_for_delete_network_sg`
- ✅ `5.2.5`: `monitor_log_alert_for_create_or_update_network_sg_rule`
- ✅ `5.2.6`: `monitor_log_alert_for_delete_network_sg_rule`
- ✅ `5.2.7`: `monitor_log_alert_for_create_or_update_security_solution`
- ✅ `5.2.8`: `monitor_log_alert_for_delete_security_solution`
- ✅ `5.2.9`: `monitor_log_alert_for_create_or_update_or_delete_sql_server_firewall_rule`
- ✅ `5.3`: `monitor_diagnostic_logs_for_all_services`
- ✅ `6.1`: `network_rdp_services_are_restricted_from_the_internet`
- ✅ `6.2`: `network_ssh_services_are_restricted_from_the_internet`
- ✅ `6.3`: `sql_no_sql_allow_ingress_from_any_ip`
- ✅ `6.4`: `network_nsg_log_retention_period`
- ✅ `6.6`: `network_udp_services_are_restricted_from_the_internet`
- ✅ `7.1`: `compute_vms_utilizing_managed_disks`
- ✅ `7.2`: `compute_os_and_data_disks_encrypted_with_cmk`
- ✅ `7.3`: `compute_unattached_disks_are_encrypted_with_cmk`
- ✅ `7.7`: `compute_vhds_not_encrypted`
- ✅ `8.1`: `keyvault_keys_without_expiration_date`
- ✅ `8.2`: `keyvault_secrets_without_expiration_date`
- ✅ `8.4`: `keyvault_not_recoverable`
- ✅ `8.5`: `container_aks_rbac_disabled`
- ✅ `9.1`: `web_app_auth_unset`
- ✅ `9.2`: `web_app_allow_http`
- ✅ `9.3`: `web_app_using_old_tls`
- ✅ `9.4`: `web_app_client_cert_disabled`
- ✅ `9.5`: `web_app_register_with_ad_disabled`
- ✅ `9.10`: `web_app_ftp_deployment_enabled`
<!-- AUTO-GENERATED-INCLUDED-CHECKS-END -->
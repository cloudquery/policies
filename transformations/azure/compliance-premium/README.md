# CloudQuery &times; dbt: Azure Compliance Package

## Overview

Welcome to Azure Compliance Package, a compliance solution that works on top of the CloudQuery framework. This package offers automated checks across various Azure services, following benchmarks such as CIS and HIPAA.
Using this solution you can get instant insights about your security posture and make sure you are following the recommended security guidelines defined by CIS and HIPAA.

### Examples

How many checks failed in the CIS 2.0 benchmark? (PostgreSQL)
```sql
SELECT count(*) as failed_count
FROM azure_compliance__cis_v2_0_0
WHERE status = 'fail'
```

Which resource failed the most tests in the HIPAA HITRUST benchmark? (PostgreSQL)
```sql
SELECT resource_id, count(*) as failed_count
FROM azure_compliance__hipaa_hitrust_v9_2
WHERE status = 'fail'
GROUP BY resource_id
ORDER BY count(*) DESC
```

### Requirements

- [dbt](https://docs.getdbt.com/docs/installation)
- [CloudQuery](https://www.cloudquery.io/docs/quickstart)
- [A CloudQuery Account](https://www.cloudquery.io/auth/register)
- [Azure Source Plugin](https://hub.cloudquery.io/plugins/source/cloudquery/azure/latest/docs)

One of the below databases

- [PostgreSQL](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql)
- [Snowflake](https://hub.cloudquery.io/plugins/destination/cloudquery/snowflake)
- [BigQuery](https://hub.cloudquery.io/plugins/destination/cloudquery/bigquery)

### What's in the pack

Automated compliance checks following CIS and HIPAA

## To run this package you need to complete the following steps

### Setting up the DBT profile (PostgreSQL)
First, [install `dbt`](https://docs.getdbt.com/docs/core/installation-overview):
```bash
pip install dbt-postgres
```

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

### Syncing Azure data
Based on the models you are interested in running, you need to sync the relevant tables.
this is an example sync for the relevant tables for all the models (views) in the policy and with the PostgreSQL destination. This package also supports Snowflake and Google BigQuery

 ```yml
kind: source
spec:
  name: azure # The source type, in this case, Azure.
  path: cloudquery/azure # The plugin path for handling Azure sources.
  registry: cloudquery # The registry from which the Azure plugin is sourced.
  version: "12.1.2" # The version of the Azure plugin.
  tables: ["azure_redis_caches","azure_storage_containers","azure_monitor_diagnostic_settings","azure_sql_managed_instance_encryption_protectors","azure_network_virtual_networks","azure_monitor_log_profiles","azure_authorization_role_definitions","azure_eventhub_namespace_network_rule_sets","azure_sql_server_database_long_term_retention_policies","azure_network_watcher_flow_logs","azure_authorization_role_assignments","azure_security_jit_network_access_policies","azure_monitor_subscription_diagnostic_settings","azure_compute_virtual_machine_extensions","azure_storage_accounts","azure_sql_server_databases","azure_mysqlflexibleservers_server_configurations","azure_postgresql_server_firewall_rules","azure_containerservice_managed_clusters","azure_compute_disks","azure_streamanalytics_streaming_jobs","azure_batch_account","azure_sql_server_database_blob_auditing_policies","azure_containerregistry_registries","azure_sql_server_advanced_threat_protection_settings","azure_network_bastion_hosts","azure_keyvault_keyvault","azure_sql_server_firewall_rules","azure_network_interfaces","azure_keyvault_keyvault_secrets","azure_sql_server_vulnerability_assessments","azure_compute_virtual_machines","azure_sql_server_admins","azure_keyvault_keyvault_keys","azure_sql_transparent_data_encryptions","azure_appservice_web_app_auth_settings","azure_applicationinsights_components","azure_sql_managed_instance_vulnerability_assessments","azure_appservice_web_app_configurations","azure_sql_servers","azure_security_contacts","azure_sql_server_encryption_protectors","azure_monitor_activity_log_alerts","azure_mysql_servers","azure_mysql_server_configurations","azure_cosmos_database_accounts","azure_eventhub_namespaces","azure_sql_managed_instances","azure_resources_links","azure_mariadb_servers","azure_network_security_groups","azure_datalakestore_accounts","azure_security_assessments","azure_security_auto_provisioning_settings","azure_security_pricings","azure_sql_server_blob_auditing_policies","azure_postgresql_server_configurations","azure_storage_blob_services","azure_logic_workflows","azure_mysqlflexibleservers_servers","azure_monitor_resources","azure_keyvault_keyvault_managed_hsms","azure_subscription_subscription_locations","azure_appservice_web_apps","azure_compute_virtual_machine_scale_sets","azure_network_watchers","azure_subscription_subscriptions","azure_postgresql_servers","azure_sql_server_virtual_network_rules","azure_appservice_web_app_vnet_connections","azure_sql_server_database_vulnerability_assessment_scans","azure_search_services",
  "azure_policy_assignments",
  "azure_network_security_groups"]
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

#### Running Your dbt Project

Navigate to your dbt project directory, where your `dbt_project.yml` resides. Make sure to have an existing profile in your `profiles.yml` that contains your PostgreSQL/Snowflake/BigQuery connection and authentication information.

If everything compiles without errors, you can then execute:

```bash
dbt run
```

This command will run all your `dbt` models and create tables/views in your destination database as defined in your models.

**Note:** If running locally, ensure you are using `dbt-core` and not `dbt-cloud-cli` as dbt-core does not require extra authentication.

To run specific models and the models in the dependency graph, the following `dbt run` commands can be used:

To select a specific model and the dependencies in the dependency graph:

```bash
dbt run --select +<model_name>
```

For a specific model and the dependencies in the dependency graph:

```bash
dbt run --models +<model_name>
```

#### Models

The following models are available for PostgreSQL, Snowflake and Google BigQuery.
- **azure_compliance\_\_cis_v1_3_0.sql**: Azure Compliance CIS V1.3.0.
- **azure_compliance\_\_cis_v2_0_0.sql**: Azure Compliance CIS V2.0.0.
- **azure_compliance\_\_cis_v2_0_0.sql**: Azure Compliance CIS V2.1.0.

- **azure_compliance\_\_hippa_hitrust_9_2.sql**: Azure Compliance HIPAA HITRUST V9.2, available for PostgreSQL.

The premium version contains all queries.

All of the models contain the following columns:
- **framework**: The benchmark the check belongs to.
- **check_id**: The check identifier (either a number or the service name and number).
- **title**: The name/title of the check.
- **resource_id**: The azure resource id.
- **subscription_id**: The azure subscription id.
- **status**: The status of the check (fail / pass).


### Required tables
- **azure_compliance\_\_cis_v1_3_0.sql**:
```yaml
"azure_monitor_activity_log_alerts",
"azure_keyvault_keyvault",
"azure_appservice_web_app_auth_settings",
"azure_storage_accounts",
"azure_sql_server_admins",
"azure_monitor_resources",
"azure_appservice_web_apps",
"azure_containerservice_managed_clusters",
"azure_sql_servers",
"azure_postgresql_server_firewall_rules",
"azure_appservice_web_app_configurations",
"azure_sql_server_firewall_rules",
"azure_authorization_role_definitions",
"azure_sql_server_advanced_threat_protection_settings",
"azure_sql_server_database_blob_auditing_policies",
"azure_compute_virtual_machines",
"azure_monitor_subscription_diagnostic_settings",
"azure_security_pricings",
"azure_compute_disks",
"azure_postgresql_server_configurations",
"azure_sql_transparent_data_encryptions",
"azure_storage_containers",
"azure_security_auto_provisioning_settings",
"azure_sql_server_databases",
"azure_keyvault_keyvault_secrets",
"azure_monitor_diagnostic_settings",
"azure_sql_server_vulnerability_assessments",
"azure_storage_blob_services",
"azure_network_watcher_flow_logs",
"azure_mysql_servers",
"azure_postgresql_servers",
"azure_keyvault_keyvault_keys",
"azure_sql_server_blob_auditing_policies",
"azure_sql_server_encryption_protectors",
"azure_policy_assignments",
"azure_network_security_groups"
```
This model is dependent on the following models:
- view_azure_security_policy_parameters
- view_azure_nsg_dest_port_ranges

- **azure_compliance\_\_cis_v2_0_0.sql**:
```yaml
"azure_monitor_activity_log_alerts",
"azure_keyvault_keyvault",
"azure_appservice_web_app_auth_settings",
"azure_storage_accounts",
"azure_sql_server_admins",
"azure_monitor_resources",
"azure_appservice_web_apps",
"azure_containerservice_managed_clusters",
"azure_sql_servers",
"azure_postgresql_server_firewall_rules",
"azure_network_watchers",
"azure_network_bastion_hosts",
"azure_appservice_web_app_configurations",
"azure_sql_server_firewall_rules",
"azure_authorization_role_definitions",
"azure_sql_server_advanced_threat_protection_settings",
"azure_sql_server_database_blob_auditing_policies",
"azure_security_contacts",
"azure_subscription_subscriptions",
"azure_compute_virtual_machines",
"azure_monitor_subscription_diagnostic_settings",
"azure_security_pricings",
"azure_compute_disks",
"azure_postgresql_server_configurations",
"azure_sql_transparent_data_encryptions",
"azure_network_virtual_networks",
"azure_storage_containers",
"azure_applicationinsights_components",
"azure_security_auto_provisioning_settings",
"azure_sql_server_databases",
"azure_keyvault_keyvault_secrets",
"azure_monitor_diagnostic_settings",
"azure_sql_server_vulnerability_assessments",
"azure_storage_blob_services",
"azure_mysql_servers",
"azure_network_watcher_flow_logs",
"azure_mysql_server_configurations",
"azure_postgresql_servers",
"azure_keyvault_keyvault_keys",
"azure_mysqlflexibleservers_servers",
"azure_sql_server_encryption_protectors",
"azure_sql_server_blob_auditing_policies",
"azure_mysqlflexibleservers_server_configurations",
"azure_policy_assignments",
"azure_network_security_groups"
```
This model is dependent on the following models:
- view_azure_security_policy_parameters
- view_azure_nsg_dest_port_ranges

- **azure_compliance\_\_cis_v2_1_0.sql**:
```yaml
"azure_network_virtual_networks",
"azure_network_watcher_flow_logs",
"azure_postgresql_server_firewall_rules",
"azure_keyvault_keyvault_secrets",
"azure_keyvault_keyvault_keys",
"azure_security_pricings",
"azure_storage_blob_services",
"azure_mysqlflexibleservers_servers",
"azure_postgresql_servers",
"azure_monitor_diagnostic_settings",
"azure_monitor_subscription_diagnostic_settings",
"azure_storage_accounts",
"azure_mysqlflexibleservers_server_configurations",
"azure_network_bastion_hosts",
"azure_keyvault_keyvault",
"azure_compute_virtual_machines",
"azure_sql_server_admins",
"azure_sql_transparent_data_encryptions",
"azure_appservice_web_app_configurations",
"azure_sql_server_encryption_protectors",
"azure_monitor_activity_log_alerts",
"azure_mysql_servers",
"azure_security_auto_provisioning_settings",
"azure_sql_server_blob_auditing_policies",
"azure_network_watchers",
"azure_storage_containers",
"azure_authorization_role_definitions",
"azure_sql_server_firewall_rules",
"azure_sql_servers",
"azure_mysql_server_configurations",
"azure_sql_server_databases",
"azure_compute_disks",
"azure_sql_server_database_blob_auditing_policies",
"azure_appservice_web_app_auth_settings",
"azure_applicationinsights_components",
"azure_security_contacts",
"azure_cosmos_database_accounts",
"azure_postgresql_server_configurations",
"azure_monitor_resources",
"azure_appservice_web_apps",
"azure_subscription_subscriptions",
"azure_policy_assignments",
"azure_network_security_groups"
```
This model is dependent on the following models:
- view_azure_security_policy_parameters
- view_azure_nsg_dest_port_ranges

- **azure_compliance\_\_hippa_hitrust_9_2.sql**:
```yaml
"azure_monitor_activity_log_alerts",
"azure_security_assessments",
"azure_subscription_subscription_locations",
"azure_search_services",
"azure_keyvault_keyvault",
"azure_network_interfaces",
"azure_storage_accounts",
"azure_appservice_web_apps",
"azure_containerservice_managed_clusters",
"azure_monitor_log_profiles",
"azure_sql_servers",
"azure_sql_managed_instance_vulnerability_assessments",
"azure_network_watchers",
"azure_network_security_groups",
"azure_compute_virtual_machine_extensions",
"azure_cosmos_database_accounts",
"azure_containerregistry_registries",
"azure_authorization_role_definitions",
"azure_sql_managed_instance_encryption_protectors",
"azure_authorization_role_assignments",
"azure_mariadb_servers",
"azure_subscription_subscriptions",
"azure_compute_virtual_machines",
"azure_keyvault_keyvault_managed_hsms",
"azure_compute_virtual_machine_scale_sets",
"azure_sql_transparent_data_encryptions",
"azure_sql_server_database_vulnerability_assessment_scans",
"azure_logic_workflows",
"azure_network_virtual_networks",
"azure_sql_server_database_long_term_retention_policies",
"azure_datalakestore_accounts",
"azure_eventhub_namespaces",
"azure_resources_links",
"azure_security_auto_provisioning_settings",
"azure_monitor_diagnostic_settings",
"azure_sql_server_databases",
"azure_sql_server_vulnerability_assessments",
"azure_mysql_servers",
"azure_postgresql_servers",
"azure_redis_caches",
"azure_sql_managed_instances",
"azure_sql_server_blob_auditing_policies",
"azure_sql_server_encryption_protectors",
"azure_streamanalytics_streaming_jobs",
"azure_eventhub_namespace_network_rule_sets",
"azure_appservice_web_app_vnet_connections",
"azure_sql_server_virtual_network_rules",
"azure_batch_account",
"azure_security_jit_network_access_policies",
"azure_network_security_groups"
```
This model is dependent on the following models:
- view_azure_nsg_rules
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
- ✅ `5.1.5`: `monitor_logging_key_vault_is_enabled`
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

##### `cis_v2.0.0`

- ✅ `1.23`: `iam_custom_subscription_owner_roles`
- ✅ `2.1.1`: `security_defender_on_for_servers`
- ✅ `2.1.2`: `security_defender_on_for_app_service`
- ✅ `2.1.3`: `security_defender_on_for_databases`
- ✅ `2.1.4`: `security_defender_on_for_sql_servers`
- ✅ `2.1.5`: `security_defender_on_for_sql_servers_on_machines`
- ✅ `2.1.7`: `security_defender_on_for_storage`
- ✅ `2.1.8`: `security_defender_on_for_container_registeries`
- ✅ `2.1.10`: `security_defender_on_for_key_vault`
- ✅ `2.1.11`: `security_defender_on_for_dns`
- ✅ `2.1.12`: `security_defender_on_for_resource_manager`
- ✅ `2.1.14`: `security_default_policy_disabled`
- ✅ `2.1.15`: `security_auto_provisioning_monitoring_agent_enabled`
- ✅ `2.1.18`: `security_emails_on_for_owner_role`
- ✅ `2.1.19`: `security_additional_security_email_configured`
- ✅ `2.1.20`: `security_notify_high_severity_alerts`
- ✅ `3.1`: `storage_secure_transfer_to_storage_accounts_should_be_enabled`
- ✅ `3.2`: `storage_infrastructure_encryption_enabled`
- ✅ `3.7`: `storage_no_public_blob_container`
- ✅ `3.8`: `storage_default_network_access_rule_is_deny`
- ✅ `3.11`: `storage_soft_delete_is_enabled`
- ✅ `3.12`: `storage_encrypt_with_cmk`
- ✅ `4.1.1`: `sql_auditing_off`
- ✅ `4.1.2`: `sql_no_sql_allow_ingress_from_any_ip`
- ✅ `4.1.3`: `sql_sqlserver_tde_not_encrypted_with_cmek`
- ✅ `4.1.4`: `sql_ad_admin_configured`
- ✅ `4.1.5`: `sql_data_encryption_off`
- ✅ `4.1.6`: `sql_auditing_retention_less_than_90_days`
- ✅ `4.2.1`: `sql_atp_on_sql_server_disabled`
- ✅ `4.2.2`: `sql_va_is_enabled_on_sql_server_by_storage_account`
- ✅ `4.2.3`: `sql_va_periodic_scans_enabled_on_sql_server`
- ✅ `4.2.4`: `sql_va_send_scan_report_enabled_on_sql_server`
- ✅ `4.2.5`: `sql_va_send_email_to_admins_and_owners_enabled`
- ✅ `4.3.1`: `sql_postgresql_ssl_enforcment_disabled`
- ✅ `4.3.2`: `sql_postgresql_log_checkpoints_disabled`
- ✅ `4.3.3`: `sql_postgresql_log_connections_disabled`
- ✅ `4.3.4`: `sql_postgresql_log_disconnections_disabled`
- ✅ `4.3.5`: `sql_postgresql_connection_throttling_disabled`
- ✅ `4.3.6`: `sql_postgresql_log_retention_days_less_than_3_days`
- ✅ `4.3.7`: `sql_postgresql_allow_access_to_azure_services_enabled`
- ✅ `4.3.8`: `sql_postgresql_infrastructure_double_encryption`
- ✅ `4.4`: `sql_ad_admin_configured`
- ✅ `4.4.1`: `sql_mysql_ssl_enforcment_disabled`
- ✅ `4.4.2`: `sql_mysql_tls_v_1_2_set`
- ✅ `4.4.3`: `sql_mysql_audit_log_enabled`
- ✅ `4.4.4`: `sql_mysql_audit_log_events_include_connection`
- ✅ `4.5`: `sql_sqlserver_tde_not_encrypted_with_cmek`
- ✅ `5.1.1`: `monitor_no_diagnostic_setting`
- ✅ `5.1.2`: `monitor_insufficient_diagnostic_capturing_settings`
- ✅ `5.1.3`: `storage_no_publicly_accessible_insights_activity_logs`
- ✅ `5.1.4`: `storage_encrypt_with_cmk_for_activity_log`
- ✅ `5.1.5`: `monitor_logging_key_vault_is_enabled`
- ✅ `5.2.1`: `monitor_log_alert_for_create_policy_assignment`
- ✅ `5.2.2`: `monitor_log_alert_for_delete_policy_assignment`
- ✅ `5.2.3`: `monitor_log_alert_for_create_or_update_network_sg`
- ✅ `5.2.4`: `monitor_log_alert_for_delete_network_sg`
- ✅ `5.2.5`: `monitor_log_alert_for_create_or_update_security_solution`
- ✅ `5.2.6`: `monitor_log_alert_for_delete_security_solution`
- ✅ `5.2.7`: `monitor_log_alert_for_create_or_update_sql_server_firewall_rule`
- ✅ `5.2.8`: `monitor_log_alert_for_delete_sql_server_firewall_rule`
- ✅ `5.2.9`: `monitor_log_alert_for_create_or_update_public_ip_address_rule`
- ✅ `5.2.10`: `monitor_log_alert_for_delete_public_ip_address_rule`
- ✅ `5.3.1`: `monitor_web_application_insights_configured`
- ✅ `5.4`: `monitor_diagnostic_logs_for_all_services`
- ✅ `5.5`: `monitor_basic_or_consumption_sku_not_used`
- ✅ `6.1`: `network_rdp_services_are_restricted_from_the_internet`
- ✅ `6.2`: `network_ssh_services_are_restricted_from_the_internet`
- ✅ `6.3`: `network_udp_services_are_restricted_from_the_internet`
- ✅ `6.4`: `network_https_access_restricted_from_the_internet`
- ✅ `6.5`: `network_nsg_log_retention_period`
- ✅ `6.6`: `network_networkwatcher_enabled`
- ✅ `7.1`: `compute_ensure_bastion_host_exists`
- ✅ `7.2`: `compute_vms_utilizing_managed_disks`
- ✅ `7.3`: `compute_os_and_data_disks_encrypted_with_cmk`
- ✅ `7.4`: `compute_unattached_disks_are_encrypted_with_cmk`
- ✅ `7.7`: `compute_vhds_not_encrypted`
- ✅ `8.1`: `keyvault_expiry_set_for_keys_in_rbac_key_vaults`
- ✅ `8.2`: `keyvault_expiry_set_for_keys_in_non_rbac_key_vaults`
- ✅ `8.3`: `keyvault_expiry_set_for_secrets_in_rbac_key_vaults`
- ✅ `8.4`: `keyvault_expiry_set_for_secrets_in_non_rbac_key_vaults`
- ✅ `8.5`: `keyvault_not_recoverable`
- ✅ `8.6`: `container_aks_rbac_disabled`
- ✅ `9.1`: `web_app_auth_unset`
- ✅ `9.2`: `web_app_allow_http`
- ✅ `9.3`: `web_app_using_old_tls`
- ✅ `9.4`: `web_app_client_cert_disabled`
- ✅ `9.5`: `web_app_register_with_ad_disabled`
- ✅ `9.10`: `web_app_ftp_deployment_enabled`
- ✅ `2.1.1`: `security_defender_on_for_servers`
- ✅ `2.1.2`: `security_defender_on_for_app_service`
- ✅ `2.1.3`: `security_defender_on_for_databases`
- ✅ `2.1.4`: `security_defender_on_for_sql_servers`
- ✅ `2.1.4`: `security_defender_on_for_sql_servers_on_machines`
- ✅ `2.1.5`: `security_defender_on_for_opensource_relational_db`
- ✅ `2.1.6`: `security_defender_on_for_cosmosdb`
- ✅ `2.1.7`: `security_defender_on_for_storage`
- ✅ `2.1.8`: `security_defender_on_for_container_registeries`
- ✅ `2.1.9`: `security_defender_on_for_key_vault`
- ✅ `2.1.10`: `security_defender_on_for_dns`
- ✅ `2.1.11`: `security_defender_on_for_resource_manager`
- ✅ `2.1.13`: `security_default_policy_disabled`
- ✅ `2.1.14`: `security_auto_provisioning_monitoring_agent_enabled`
- ✅ `2.1.16`: `security_defender_on_for_containers`
- ✅ `2.1.17`: `security_emails_on_for_owner_role`
- ✅ `2.1.18`: `security_additional_security_email_configured`
- ✅ `2.1.19`: `security_notify_high_severity_alerts`
- ✅ `3.1`: `storage_secure_transfer_to_storage_accounts_should_be_enabled`
- ✅ `3.2`: `storage_infrastructure_encryption_enabled`
- ✅ `3.7`: `storage_account_public_network_access`
- ✅ `3.8`: `storage_default_network_access_rule_is_deny`
- ✅ `3.10`: `storage_account_uses_private_link`
- ✅ `3.11`: `storage_soft_delete_is_enabled`
- ✅ `3.12`: `storage_encrypt_with_cmk`
- ✅ `3.15`: `storage_account_min_tls_1_2`
- ✅ `3.17`: `storage_no_public_blob_container`
- ✅ `4.1.1`: `sql_auditing_off`
- ✅ `4.1.2`: `sql_no_sql_allow_ingress_from_any_ip`
- ✅ `4.1.3`: `sql_sqlserver_tde_not_encrypted_with_cmek`
- ✅ `4.1.4`: `sql_ad_admin_configured`
- ✅ `4.1.5`: `sql_data_encryption_off`
- ✅ `4.1.6`: `sql_auditing_retention_less_than_90_days`
- ✅ `4.3.1`: `sql_postgresql_ssl_enforcment_disabled`
- ✅ `4.3.2`: `sql_postgresql_log_checkpoints_disabled`
- ✅ `4.3.3`: `sql_postgresql_log_connections_disabled`
- ✅ `4.3.4`: `sql_postgresql_log_disconnections_disabled`
- ✅ `4.3.5`: `sql_postgresql_connection_throttling_disabled`
- ✅ `4.3.6`: `sql_postgresql_log_retention_days_less_than_3_days`
- ✅ `4.3.7`: `sql_postgresql_allow_access_to_azure_services_enabled`
- ✅ `4.3.8`: `sql_postgresql_infrastructure_double_encryption`
- ✅ `4.4.1`: `sql_mysql_ssl_enforcment_disabled`
- ✅ `4.4.2`: `sql_mysql_tls_v_1_2_set`
- ✅ `4.4.3`: `sql_mysql_audit_log_enabled`
- ✅ `4.4.4`: `sql_mysql_audit_log_events_include_connection`
- ✅ `4.5`: `sql_sqlserver_tde_not_encrypted_with_cmek`
- ✅ `4.5.1`: `cosmosdb_cosmos_db_should_use_a_virtual_network_service_endpoint`
- ✅ `4.5.2`: `cosmosdb_account_uses_private_link`
- ✅ `5.1.1`: `monitor_no_diagnostic_setting`
- ✅ `5.1.2`: `monitor_insufficient_diagnostic_capturing_settings`
- ✅ `5.1.3`: `storage_encrypt_with_cmk_for_activity_log`
- ✅ `5.1.4`: `monitor_logging_key_vault_is_enabled`
- ✅ `5.2.1`: `monitor_log_alert_for_create_policy_assignment`
- ✅ `5.2.2`: `monitor_log_alert_for_delete_policy_assignment`
- ✅ `5.2.3`: `monitor_log_alert_for_create_or_update_network_sg`
- ✅ `5.2.4`: `monitor_log_alert_for_delete_network_sg`
- ✅ `5.2.5`: `monitor_log_alert_for_create_or_update_security_solution`
- ✅ `5.2.6`: `monitor_log_alert_for_delete_security_solution`
- ✅ `5.2.7`: `monitor_log_alert_for_create_or_update_sql_server_firewall_rule`
- ✅ `5.2.8`: `monitor_log_alert_for_delete_sql_server_firewall_rule`
- ✅ `5.2.9`: `monitor_log_alert_for_create_or_update_public_ip_address_rule`
- ✅ `5.2.10`: `monitor_log_alert_for_delete_public_ip_address_rule`
- ✅ `5.3.1`: `monitor_web_application_insights_configured`
- ✅ `5.4`: `monitor_diagnostic_logs_for_all_services`
- ✅ `5.5`: `monitor_basic_or_consumption_sku_not_used`
- ✅ `6.1`: `network_rdp_services_are_restricted_from_the_internet`
- ✅ `6.2`: `network_ssh_services_are_restricted_from_the_internet`
- ✅ `6.3`: `network_udp_services_are_restricted_from_the_internet`
- ✅ `6.4`: `network_https_access_restricted_from_the_internet`
- ✅ `6.5`: `network_nsg_log_retention_period`
- ✅ `6.6`: `network_networkwatcher_enabled`
- ✅ `7.1`: `compute_ensure_bastion_host_exists`
- ✅ `7.2`: `compute_vms_utilizing_managed_disks`
- ✅ `7.3`: `compute_os_and_data_disks_encrypted_with_cmk`
- ✅ `7.4`: `compute_unattached_disks_are_encrypted_with_cmk`
- ✅ `7.7`: `compute_vhds_not_encrypted`
- ✅ `8.1`: `keyvault_expiry_set_for_keys_in_rbac_key_vaults`
- ✅ `8.2`: `keyvault_expiry_set_for_keys_in_non_rbac_key_vaults`
- ✅ `8.3`: `keyvault_expiry_set_for_secrets_in_rbac_key_vaults`
- ✅ `8.4`: `keyvault_expiry_set_for_secrets_in_non_rbac_key_vaults`
- ✅ `8.5`: `keyvault_not_recoverable`
- ✅ `8.6`: `keyvault_rbac_enabled`
- ✅ `8.7`: `keyvault_vault_private_link_used`
- ✅ `9.1`: `web_app_auth_unset`
- ✅ `9.2`: `web_app_allow_http`
- ✅ `9.3`: `web_app_using_old_tls`
- ✅ `9.4`: `web_app_register_with_ad_disabled`
- ✅ `9.5`: `app_using_latest_php_version`
- ✅ `9.6`: `app_using_latest_python_version`
- ✅ `9.7`: `app_using_latest_java_version`
- ✅ `9.8`: `app_using_latest_http_version`
- ✅ `9.9`: `web_app_ftp_deployment_enabled`

##### `cis_v2.1.0`

- ✅ `1.23`: `iam_custom_subscription_owner_roles`

##### `hipaa_hitrust_v9.2`

- ✅ `0201.09j1Organizational.124 - 09.j - 2`: `compute_vmantimalwareextension_deploy`
- ✅ `0201.09j1Organizational.124 - 09.j - 3`: `compute_endpoint_protection_solution_should_be_installed_on_virtual_machine_scale_sets`
- ✅ `0201.09j1Organizational.124 - 09.j - 4`: `compute_virtualmachines_antimalwareautoupdate_auditifnotexists`
- ✅ `0201.09j1Organizational.124 - 09.j - 6`: `compute_asc_missingsystemupdates_audit`
- ✅ `0301.09o1Organizational.123 - 09.o - 1`: `sql_data_encryption_off`
- ✅ `0304.09o3Organizational.1 - 09.o - 1`: `datalake_not_encrypted_storage_accounts`
- ✅ `0304.09o3Organizational.1 - 09.o - 2`: `sql_managed_instances_without_cmk_at_rest`
- ✅ `0304.09o3Organizational.1 - 09.o - 3`: `sql_sqlserver_tde_not_encrypted_with_cmek`
- ✅ `0662.09sCSPOrganizational.2 - 09.s - 1`: `web_app_client_cert_disabled`
- ✅ `0709.10m1Organizational.1 - 10.m - 1`: `compute_machines_without_vulnerability_assessment_extension`
- ✅ `0709.10m1Organizational.1 - 10.m - 2`: `sql_sql_databases_with_unresolved_vulnerability_findings`
- ✅ `0709.10m1Organizational.1 - 10.m - 6`: `sql_managed_instances_without_vulnerability_assessments`
- ✅ `0709.10m1Organizational.1 - 10.m - 7`: `sql_servers_without_vulnerability_assessments`
- ✅ `0805.01m1Organizational.12 - 01.m - 5`: `network_gateway_subnets_should_not_be_configured_with_a_network_security_group`
- ✅ `0805.01m1Organizational.12 - 01.m - 8`: `sql_sql_servers_with_no_service_endpoint`
- ✅ `0805.01m1Organizational.12 - 01.m - 9`: `storage_accounts_with_no_service_endpoint_associated`
- ✅ `0806.01m2Organizational.12356 - 01.m - 1`: `container_containers_without_virtual_service_endpoint`
- ✅ `0806.01m2Organizational.12356 - 01.m - 2`: `network_virtualnetworkserviceendpoint_appservice_auditifnotexists`
- ✅ `0806.01m2Organizational.12356 - 01.m - 3`: `cosmosdb_cosmos_db_should_use_a_virtual_network_service_endpoint`
- ✅ `0806.01m2Organizational.12356 - 01.m - 4`: `eventhub_event_hub_should_use_a_virtual_network_service_endpoint`
- ✅ `0806.01m2Organizational.12356 - 01.m - 6`: `compute_internet_facing_virtual_machines_should_be_protected_with_network_security_groups`
- ✅ `0806.01m2Organizational.12356 - 01.m - 7`: `keyvault_vaults_with_no_service_endpoint`
- ✅ `0806.01m2Organizational.12356 - 01.m - 10`: `network_subnets_without_nsg_associated`
- ✅ `0806.01m2Organizational.12356 - 01.m - 11`: `compute_vms_without_approved_networks`
- ✅ `0809.01n2Organizational.1234 - 01.n - 3`: `mysql_enforce_ssl_connection_should_be_enabled_for_mysql_database_servers`
- ✅ `0809.01n2Organizational.1234 - 01.n - 4`: `postgresql_enforce_ssl_connection_should_be_enabled_for_postgresql_database_servers`
- ✅ `0809.01n2Organizational.1234 - 01.n - 5`: `web_function_app_should_only_be_accessible_over_https`
- ✅ `0809.01n2Organizational.1234 - 01.n - 7`: `web_latest_tls_version_should_be_used_in_your_api_app`
- ✅ `0809.01n2Organizational.1234 - 01.n - 8`: `web_latest_tls_version_should_be_used_in_your_function_app`
- ✅ `0809.01n2Organizational.1234 - 01.n - 9`: `web_latest_tls_version_should_be_used_in_your_web_app`
- ✅ `0809.01n2Organizational.1234 - 01.n - 14`: `web_web_application_should_only_be_accessible_over_https`
- ✅ `0835.09n1Organizational.1 - 09.n - 1`: `compute_windows_machines_without_data_collection_agent`
- ✅ `0835.09n1Organizational.1 - 09.n - 2`: `compute_vms_no_resource_manager`
- ✅ `0836.09.n2Organizational.1 - 09.n - 1`: `compute_linux_machines_without_data_collection_agent`
- ✅ `0858.09m1Organizational.4 - 09.m - 1`: `network_asc_unprotectedendpoints_audit`
- ✅ `0866.09m3Organizational.1516 - 09.m - 1`: `storage_accounts_with_unrestricted_access`
- ✅ `0886.09n2Organizational.4 - 09.n - 1`: `account_locations_without_network_watchers`
- ✅ `0901.09s1Organizational.1 - 09.s - 1`: `web_cors_should_not_allow_every_resource_to_access_your_web_applications`
- ✅ `0902.09s2Organizational.13 - 09.s - 1`: `web_cors_should_not_allow_every_resource_to_access_your_function_apps`
- ✅ `0911.09s1Organizational.2 - 09.s - 1`: `web_cors_should_not_allow_every_resource_to_access_your_api_app`
- ✅ `0912.09s1Organizational.4 - 09.s - 1`: `web_remote_debugging_should_be_turned_off_for_web_applications`
- ✅ `0913.09s1Organizational.5 - 09.s - 1`: `web_remote_debugging_should_be_turned_off_for_function_apps`
- ✅ `0914.09s1Organizational.6 - 09.s - 1`: `web_remote_debugging_should_be_turned_off_for_api_apps`
- ✅ `0949.09y2Organizational.5 - 09.y - 1`: `web_api_app_should_only_be_accessible_over_https`
- ✅ `1116_01j1organizational_145_01_j`: `security_mfa_should_be_enabled_on_accounts_with_owner_permissions_on_your_subscription`
- ✅ `1117_01j1organizational_23_01_j`: `security_mfa_should_be_enabled_accounts_with_write_permissions_on_your_subscription`
- ✅ `1118_01j2organizational_124_01_j`: `security_mfa_should_be_enabled_on_accounts_with_read_permissions_on_your_subscription`
- ✅ `1119_01j2organizational_3_01_j`: `compute_virtual_machines_without_jit_network_access_policy`
- ✅ `1120.09ab3System.9 - 09.ab - 1`: `monitor_azure_monitor_should_collect_activity_logs_from_all_regions`
- ✅ `1202.09aa1System.1 - 09.aa - 1`: `datalake_datalake_storage_accounts_with_disabled_logging`
- ✅ `1203.09aa1System.2 - 09.aa - 1`: `logic_app_workflow_logging_enabled`
- ✅ `1205.09aa2System.1 - 09.aa - 1`: `batch_resource_logs_in_batch_accounts_should_be_enabled`
- ✅ `1206.09aa2System.23 - 09.aa - 1`: `compute_virtual_machine_scale_sets_without_logs`
- ✅ `1207.09aa2System.4 - 09.aa - 1`: `streamanalytics_resource_logs_in_azure_stream_analytics_should_be_enabled`
- ✅ `1207.09aa2System.4 - 09.aa - 2`: `eventhub_namespaces_without_logging`
- ✅ `1208.09aa3System.1 - 09.aa - 1`: `search_resource_logs_in_search_services_should_be_enabled`
- ✅ `1209.09aa3System.2 - 09.aa - 1`: `web_apps_with_logging_disabled`
- ✅ `1211.09aa3System.4 - 09.aa - 1`: `sql_sqlserverauditing_audit`
- ✅ `1211.09aa3System.4 - 09.aa - 2`: `keyvault_hsms_without_logging`
- ✅ `1211.09aa3System.4 - 09.aa - 3`: `keyvault_vaults_without_logging`
- ✅ `1212.09ab1System.1 - 09.ab - 1`: `monitor_azure_monitor_log_profile_should_collect_logs_for_categories_write_delete_and_action`
- ✅ `1213.09ab2System.128 - 09.ab - 1`: `security_asc_automatic_provisioning_log_analytics_monitoring_agent`
- ✅ `1229.09c1Organizational.1 - 09.c - 1`: `container_aks_rbac_disabled`
- ✅ `1230.09c2Organizational.1 - 09.c - 1`: `authorization_custom_roles`
- ✅ `1232.09c3Organizational.12 - 09.c - 1`: `network_rdp_access_permitted`
- ✅ `1270.09ad1System.12 - 09.ad - 1`: `monitor_activitylog_administrativeoperations_audit`
- ✅ `1401.05i1Organizational.1239 - 05.i - 1`: `storage_secure_transfer_to_storage_accounts_should_be_enabled`
- ✅ `1451.05iCSPOrganizational.2 - 05.i - 1`: `redis_only_secure_connections_to_your_azure_cache_for_redis_should_be_enabled`
- ✅ `1616.09l1Organizational.16 - 09.l - 1`: `sql_long_term_geo_redundant_backup_should_be_enabled_for_azure_sql_databases`
- ✅ `1617.09l1Organizational.23 - 09.l - 1`: `sql_mysql_servers_without_geo_redundant_backups`
- ✅ `1618.09l1Organizational.45 - 09.l - 1`: `sql_postgresql_servers_without_geo_redundant_backups`
- ✅ `1619.09l1Organizational.7 - 09.l - 1`: `sql_mariadb_servers_without_geo_redundant_backups`
- ✅ `1634.12b1Organizational.1 - 12.b - 1`: `compute_audit_virtual_machines_without_disaster_recovery_configured`
- ✅ `1635.12b1Organizational.2 - 12.b - 1`: `keyvault_azure_key_vault_managed_hsm_should_have_purge_protection_enabled`
- ✅ `1635.12b1Organizational.2 - 12.b - 2`: `keyvault_not_recoverable`
- ✅ `11112.01q2Organizational.67 - 01.q - 1`: `authorization_subscriptions_with_more_than_3_owners`
- ✅ `11208.01q1Organizational.8 - 01.q - 1`: `authorization_subscriptions_with_less_than_2_owners`
- ✅ `12100.09ab2System.15 - 09.ab - 1`: `compute_machines_without_log_analytics_agent`
- ✅ `12101.09ab1Organizational.3 - 09.ab - 1`: `compute_scale_sets_without_log_analytics_agent`
- ✅ `12102.09ab1Organizational.4 - 09.ab - 1`: `compute_guestconfiguration_windowsloganalyticsagentconnection_aine`
<!-- AUTO-GENERATED-INCLUDED-CHECKS-END -->
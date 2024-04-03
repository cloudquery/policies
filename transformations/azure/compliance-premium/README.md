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

##### `cis_v2.1.0`

- ✅ `2.1.5`: `security_defender_on_for_opensource_relational_db`
- ✅ `2.1.6`: `security_defender_on_for_cosmosdb`
- ✅ `2.1.16`: `security_defender_on_for_containers`
- ✅ `3.7`: `storage_account_public_network_access`
- ✅ `3.10`: `storage_account_uses_private_link`
- ✅ `3.15`: `storage_account_min_tls_1_2`
- ✅ `4.5.2`: `cosmosdb_account_uses_private_link`
- ✅ `8.6`: `keyvault_rbac_enabled`
- ✅ `8.7`: `keyvault_vault_private_link_used`
- ✅ `9.5`: `app_using_latest_php_version`
- ✅ `9.6`: `app_using_latest_python_version`
- ✅ `9.7`: `app_using_latest_java_version`
- ✅ `9.8`: `app_using_latest_http_version`

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
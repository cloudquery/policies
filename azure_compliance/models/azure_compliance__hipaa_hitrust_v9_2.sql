with
    aggregated as (
--User Authentication for External Connections  
({{security_mfa_should_be_enabled_on_accounts_with_owner_permissions_on_your_subscription('cis_v1.3.0','1116_01j1organizational_145_01_j')}})
union
({{security_mfa_should_be_enabled_accounts_with_write_permissions_on_your_subscription('cis_v1.3.0','1117_01j1organizational_23_01_j')}})
union        
({{security_mfa_should_be_enabled_on_accounts_with_read_permissions_on_your_subscription('cis_v1.3.0','1118_01j2organizational_124_01_j')}})
union        
({{compute_virtual_machines_without_jit_network_access_policy('cis_v1.3.0','1119_01j2organizational_3_01_j')}})
union        
({{security_mfa_should_be_enabled_on_accounts_with_owner_permissions_on_your_subscription('cis_v1.3.0','1121_01j3organizational_2_01_j')}})
union
({{security_mfa_should_be_enabled_accounts_with_write_permissions_on_your_subscription('cis_v1.3.0','1173_01j1organizational_6_01_j')}})
union        
({{security_mfa_should_be_enabled_on_accounts_with_read_permissions_on_your_subscription('cis_v1.3.0','1174_01j1organizational_7_01_j')}})
union
({{compute_virtual_machines_without_jit_network_access_policy('cis_v1.3.0','1175_01j1organizational_8_01_j')}})
union
--segregation_in_networks
({{security_mfa_should_be_enabled_on_accounts_with_owner_permissions_on_your_subscription('cis_v1.3.0','1176_01j2organizational_5_01_j')}})
union
({{security_mfa_should_be_enabled_accounts_with_write_permissions_on_your_subscription('cis_v1.3.0','1177_01j2organizational_6_01_j')}})
union
({{security_mfa_should_be_enabled_on_accounts_with_read_permissions_on_your_subscription('cis_v1.3.0','1178_01j2organizational_7_01_j')}})
union
({{compute_virtual_machines_without_jit_network_access_policy('cis_v1.3.0','1179_01j3organizational_1_01_j')}})
union
({{compute_vms_without_approved_networks('cis_v1.3.0','0806.01m2Organizational.12356 - 01.m - 11')}})
union
({{network_subnets_without_nsg_associated('cis_v1.3.0','0806.01m2Organizational.12356 - 01.m - 10')}})
union
({{storage_accounts_with_no_service_endpoint_associated('cis_v1.3.0','0806.01m2Organizational.12356 - 01.m - 9')}})
union
({{keyvault_vaults_with_no_service_endpoint('cis_v1.3.0','0806.01m2Organizational.12356 - 01.m - 7')}})
union
({{compute_internet_facing_virtual_machines_should_be_protected_with_network_security_groups('cis_v1.3.0','0806.01m2Organizational.12356 - 01.m - 6')}})
union 
({{eventhub_event_hub_should_use_a_virtual_network_service_endpoint('cis_v1.3.0','0806.01m2Organizational.12356 - 01.m - 4')}})
union
({{cosmosdb_cosmos_db_should_use_a_virtual_network_service_endpoint('cis_v1.3.0','0806.01m2Organizational.12356 - 01.m - 3')}})
union
({{network_virtualnetworkserviceendpoint_appservice_auditifnotexists('cis_v1.3.0','0806.01m2Organizational.12356 - 01.m - 2')}})
union
({{container_containers_without_virtual_service_endpoint('cis_v1.3.0','0806.01m2Organizational.12356 - 01.m - 1')}})
union
({{compute_vms_without_approved_networks('cis_v1.3.0','0805.01m1Organizational.12 - 01.m - 11')}})
union
({{network_subnets_without_nsg_associated('cis_v1.3.0','0805.01m1Organizational.12 - 01.m - 10')}})
union
({{storage_accounts_with_no_service_endpoint_associated('cis_v1.3.0','0805.01m1Organizational.12 - 01.m - 9')}})
union
({{sql_sql_servers_with_no_service_endpoint('cis_v1.3.0','0805.01m1Organizational.12 - 01.m - 8')}})
union
({{keyvault_vaults_with_no_service_endpoint('cis_v1.3.0','0805.01m1Organizational.12 - 01.m - 7')}})
union
({{compute_internet_facing_virtual_machines_should_be_protected_with_network_security_groups('cis_v1.3.0','0805.01m1Organizational.12 - 01.m - 6')}})
union
({{network_gateway_subnets_should_not_be_configured_with_a_network_security_group('0805.01m1Organizational.12 - 01.m - 5')}})
union
({{eventhub_event_hub_should_use_a_virtual_network_service_endpoint('cis_v1.3.0','0805.01m1Organizational.12 - 01.m - 4')}})
union
({{cosmosdb_cosmos_db_should_use_a_virtual_network_service_endpoint('cis_v1.3.0','0805.01m1Organizational.12 - 01.m - 3')}})
union
({{network_virtualnetworkserviceendpoint_appservice_auditifnotexists('cis_v1.3.0','0805.01m1Organizational.12 - 01.m - 2')}})
union
({{container_containers_without_virtual_service_endpoint('cis_v1.3.0','0805.01m1Organizational.12 - 01.m - 1')}})
union
--network_connection_control
({{web_api_app_should_only_be_accessible_over_https('cis_v1.3.0','0809.01n2Organizational.1234 - 01.n - 2')}})
union
({{mysql_enforce_ssl_connection_should_be_enabled_for_mysql_database_servers('cis_v1.3.0','0809.01n2Organizational.1234 - 01.n - 3')}})
union
({{postgresql_enforce_ssl_connection_should_be_enabled_for_postgresql_database_servers('cis_v1.3.0','0809.01n2Organizational.1234 - 01.n - 4')}})
union
({{web_function_app_should_only_be_accessible_over_https('cis_v1.3.0','0809.01n2Organizational.1234 - 01.n - 5')}})
union
({{compute_internet_facing_virtual_machines_should_be_protected_with_network_security_groups('cis_v1.3.0','0809.01n2Organizational.1234 - 01.n - 6')}})
union
({{web_latest_tls_version_should_be_used_in_your_api_app('cis_v1.3.0','0809.01n2Organizational.1234 - 01.n - 7')}})
union
({{web_latest_tls_version_should_be_used_in_your_function_app('cis_v1.3.0','0809.01n2Organizational.1234 - 01.n - 8')}})
union
({{web_latest_tls_version_should_be_used_in_your_web_app('cis_v1.3.0','0809.01n2Organizational.1234 - 01.n - 9')}})
union
({{redis_only_secure_connections_to_your_azure_cache_for_redis_should_be_enabled('cis_v1.3.0','0809.01n2Organizational.1234 - 01.n - 10')}})
union
({{storage_secure_transfer_to_storage_accounts_should_be_enabled('cis_v1.3.0','0809.01n2Organizational.1234 - 01.n - 11')}})
union
({{network_subnets_without_nsg_associated('cis_v1.3.0','0809.01n2Organizational.1234 - 01.n - 12')}})
union
({{compute_vms_without_approved_networks('cis_v1.3.0','0809.01n2Organizational.1234 - 01.n - 13')}})
union
({{web_web_application_should_only_be_accessible_over_https('cis_v1.3.0','0809.01n2Organizational.1234 - 01.n - 14')}})
--user_identification_and_authentication
union
({{security_mfa_should_be_enabled_on_accounts_with_owner_permissions_on_your_subscription('cis_v1.3.0','11109.01q1Organizational.57 - 01.q - 1')}})
union
({{security_mfa_should_be_enabled_accounts_with_write_permissions_on_your_subscription('cis_v1.3.0','11110.01q1Organizational.6 - 01.q - 1')}})
union
({{security_mfa_should_be_enabled_on_accounts_with_read_permissions_on_your_subscription('cis_v1.3.0','11111.01q2System.4 - 01.q - 1')}})
union
({{authorization_subscriptions_with_more_than_3_owners('cis_v1.3.0','11112.01q2Organizational.67 - 01.q - 1')}})
union
({{authorization_subscriptions_with_less_than_2_owners('cis_v1.3.0','11208.01q1Organizational.8 - 01.q - 1')}})
--identification_of_risks_related_to_external_parties
union
({{storage_secure_transfer_to_storage_accounts_should_be_enabled('cis_v1.3.0','1401.05i1Organizational.1239 - 05.i - 1')}})
union
({{web_function_app_should_only_be_accessible_over_https('cis_v1.3.0','1402.05i1Organizational.45 - 05.i - 1')}})
union
({{web_web_application_should_only_be_accessible_over_https('cis_v1.3.0','1403.05i1Organizational.67 - 05.i - 1')}})
union
({{mysql_enforce_ssl_connection_should_be_enabled_for_mysql_database_servers('cis_v1.3.0','1418.05i1Organizational.8 - 05.i - 1')}})
union
({{postgresql_enforce_ssl_connection_should_be_enabled_for_postgresql_database_servers('cis_v1.3.0','1450.05i2Organizational.2 - 05.i - 1')}})
union
({{redis_only_secure_connections_to_your_azure_cache_for_redis_should_be_enabled('cis_v1.3.0','1451.05iCSPOrganizational.2 - 05.i - 1')}})
--audit_logging
union
({{datalake_datalake_storage_accounts_with_disabled_logging('cis_v1.3.0','1202.09aa1System.1 - 09.aa - 1')}})
union
({{logic_app_workflow_logging_enabled('cis_v1.3.0','1203.09aa1System.2 - 09.aa - 1')}})
union
({{batch_resource_logs_in_batch_accounts_should_be_enabled('cis_v1.3.0','1205.09aa2System.1 - 09.aa - 1')}})
union
({{compute_virtual_machine_scale_sets_without_logs('cis_v1.3.0','1206.09aa2System.23 - 09.aa - 1')}})
union
({{streamanalytics_resource_logs_in_azure_stream_analytics_should_be_enabled('cis_v1.3.0','1207.09aa2System.4 - 09.aa - 1')}})
union
({{eventhub_namespaces_without_logging('cis_v1.3.0','1207.09aa2System.4 - 09.aa - 2')}})
union
({{search_resource_logs_in_search_services_should_be_enabled('cis_v1.3.0','1208.09aa3System.1 - 09.aa - 1')}})
union
({{web_apps_with_logging_disabled('cis_v1.3.0','1209.09aa3System.2 - 09.aa - 1')}})
union
({{sql_sqlserverauditing_audit('cis_v1.3.0','1211.09aa3System.4 - 09.aa - 1')}})
union
({{keyvault_hsms_without_logging('cis_v1.3.0','1211.09aa3System.4 - 09.aa - 2')}})
union
({{keyvault_vaults_without_logging('cis_v1.3.0','1211.09aa3System.4 - 09.aa - 3')}})
--monitoring_system_use
union
({{monitor_azure_monitor_should_collect_activity_logs_from_all_regions('cis_v1.3.0','1120.09ab3System.9 - 09.ab - 1')}})
--dup
union
({{compute_machines_without_log_analytics_agent('cis_v1.3.0','12100.09ab2System.15 - 09.ab - 1')}})
union
({{compute_scale_sets_without_log_analytics_agent('cis_v1.3.0','12101.09ab1Organizational.3 - 09.ab - 1')}})
--dup
union
({{compute_guestconfiguration_windowsloganalyticsagentconnection_aine('cis_v1.3.0','12102.09ab1Organizational.4 - 09.ab - 1')}})
union
({{monitor_azure_monitor_log_profile_should_collect_logs_for_categories_write_delete_and_action('cis_v1.3.0','1212.09ab1System.1 - 09.ab - 1')}})
union
({{security_asc_automatic_provisioning_log_analytics_monitoring_agent('cis_v1.3.0','1213.09ab2System.128 - 09.ab - 1')}})
union
({{monitor_azure_monitor_should_collect_activity_logs_from_all_regions('cis_v1.3.0','1214.09ab2System.3456 - 09.ab - 1')}})
union
({{compute_machines_without_log_analytics_agent('cis_v1.3.0','1215.09ab2System.7 - 09.ab - 1')}})
--dup
union
({{compute_scale_sets_without_log_analytics_agent('cis_v1.3.0','1216.09ab3System.12 - 09.ab - 1')}})
union
({{monitor_azure_monitor_log_profile_should_collect_logs_for_categories_write_delete_and_action('cis_v1.3.0','1217.09ab3System.3 - 09.ab - 1')}})
--dup
union
({{monitor_azure_monitor_log_profile_should_collect_logs_for_categories_write_delete_and_action('cis_v1.3.0','1219.09ab3System.10 - 09.ab - 1')}})
--dup
union
({{security_asc_automatic_provisioning_log_analytics_monitoring_agent('cis_v1.3.0','1220.09ab3System.56 - 09.ab - 1')}})
--dup
--administrator_and_operator_logs
union
({{monitor_activitylog_administrativeoperations_audit('cis_v1.3.0','1270.09ad1System.12 - 09.ad - 1')}})
union
({{monitor_activitylog_administrativeoperations_audit('cis_v1.3.0','1271.09ad1System.1 - 09.ad - 1')}})
--dup
--segregation_of_duties
union
({{container_aks_rbac_disabled('cis_v1.3.0','1229.09c1Organizational.1 - 09.c - 1')}})
union
({{authorization_custom_roles('cis_v1.3.0','1230.09c2Organizational.1 - 09.c - 1')}})
union
({{network_rdp_access_permitted('cis_v1.3.0','1232.09c3Organizational.12 - 09.c - 1')}})
--controls_against_malicious_code
union
({{compute_vmantimalwareextension_deploy('cis_v1.3.0','0201.09j1Organizational.124 - 09.j - 2')}})
union
({{compute_endpoint_protection_solution_should_be_installed_on_virtual_machine_scale_sets('cis_v1.3.0','0201.09j1Organizational.124 - 09.j - 3')}})
union
({{compute_virtualmachines_antimalwareautoupdate_auditifnotexists('cis_v1.3.0','0201.09j1Organizational.124 - 09.j - 4')}})
union
({{compute_asc_missingsystemupdates_audit('cis_v1.3.0','0201.09j1Organizational.124 - 09.j - 6')}})
--back_up
union
({{sql_long_term_geo_redundant_backup_should_be_enabled_for_azure_sql_databases('cis_v1.3.0','1616.09l1Organizational.16 - 09.l - 1')}})
union
({{sql_mysql_servers_without_geo_redundant_backups('cis_v1.3.0','1617.09l1Organizational.23 - 09.l - 1')}})
union
({{sql_postgresql_servers_without_geo_redundant_backups('cis_v1.3.0','1618.09l1Organizational.45 - 09.l - 1')}})
union
({{sql_mariadb_servers_without_geo_redundant_backups('cis_v1.3.0','1619.09l1Organizational.7 - 09.l - 1')}})
union
({{sql_long_term_geo_redundant_backup_should_be_enabled_for_azure_sql_databases('cis_v1.3.0','1621.09l2Organizational.1 - 09.l - 1')}})
--dup
union
({{sql_mysql_servers_without_geo_redundant_backups('cis_v1.3.0','1622.09l2Organizational.23 - 09.l - 1')}})
--dup
union
({{sql_postgresql_servers_without_geo_redundant_backups('cis_v1.3.0','1623.09l2Organizational.4 - 09.l - 1')}})
--dup
union
({{sql_mariadb_servers_without_geo_redundant_backups('cis_v1.3.0','1624.09l3Organizational.12 - 09.l - 1')}})
--dup
union
({{sql_postgresql_servers_without_geo_redundant_backups('cis_v1.3.0','1626.09l3Organizational.5 - 09.l - 1')}})
union
--dup
({{sql_mariadb_servers_without_geo_redundant_backups('cis_v1.3.0','1627.09l3Organizational.6 - 09.l - 1')}})
--network_controls
union
({{network_asc_unprotectedendpoints_audit('cis_v1.3.0','0858.09m1Organizational.4 - 09.m - 1')}})
union
({{compute_virtual_machines_without_jit_network_access_policy('cis_v1.3.0','0858.09m1Organizational.4 - 09.m - 2')}})
union
({{network_virtualnetworkserviceendpoint_appservice_auditifnotexists('cis_v1.3.0','0861.09m2Organizational.67 - 09.m - 1')}})
union
({{eventhub_event_hub_should_use_a_virtual_network_service_endpoint('cis_v1.3.0','0863.09m2Organizational.910 - 09.m - 1')}})
union
({{cosmosdb_cosmos_db_should_use_a_virtual_network_service_endpoint('cis_v1.3.0','0864.09m2Organizational.12 - 09.m - 1')}})
union
({{keyvault_vaults_with_no_service_endpoint('cis_v1.3.0','0865.09m2Organizational.13 - 09.m - 1')}})
union
({{storage_accounts_with_unrestricted_access('cis_v1.3.0','0866.09m3Organizational.1516 - 09.m - 1')}})
union
({{storage_accounts_with_no_service_endpoint_associated('cis_v1.3.0','0867.09m3Organizational.17 - 09.m - 1')}})
union
({{container_containers_without_virtual_service_endpoint('cis_v1.3.0','0868.09m3Organizational.18 - 09.m - 1')}})
--dup
union
({{container_containers_without_virtual_service_endpoint('cis_v1.3.0','0869.09m3Organizational.19 - 09.m - 1')}})
--dup
union
({{container_containers_without_virtual_service_endpoint('cis_v1.3.0','0870.09m3Organizational.20 - 09.m - 1')}})
--dup
union
({{container_containers_without_virtual_service_endpoint('cis_v1.3.0','0871.09m3Organizational.22 - 09.m - 1')}})
--dup
--security_of_network_services
union
({{compute_windows_machines_without_data_collection_agent('cis_v1.3.0','0835.09n1Organizational.1 - 09.n - 1')}})
union
({{compute_vms_no_resource_manager('cis_v1.3.0','0835.09n1Organizational.1 - 09.n - 2')}})
union
({{compute_linux_machines_without_data_collection_agent('cis_v1.3.0','0836.09.n2Organizational.1 - 09.n - 1')}})
union
({{account_locations_without_network_watchers('cis_v1.3.0','0837.09.n2Organizational.2 - 09.n - 1')}})
union
({{compute_linux_machines_without_data_collection_agent('cis_v1.3.0','0885.09n2Organizational.3 - 09.n - 1')}})
--dup
union
({{account_locations_without_network_watchers('cis_v1.3.0','0886.09n2Organizational.4 - 09.n - 1')}})
--dup
union
({{compute_windows_machines_without_data_collection_agent('cis_v1.3.0','0887.09n2Organizational.5 - 09.n - 1')}})
--dup
union
({{account_locations_without_network_watchers('cis_v1.3.0','0888.09n2Organizational.6 - 09.n - 1')}})
--dup
--management_of_removable_media
union
({{sql_data_encryption_off('cis_v1.3.0','0301.09o1Organizational.123 - 09.o - 1')}})
union
({{datalake_not_encrypted_storage_accounts('cis_v1.3.0','0304.09o3Organizational.1 - 09.o - 1')}})
union
({{sql_managed_instances_without_cmk_at_rest('cis_v1.3.0','0304.09o3Organizational.1 - 09.o - 2')}})
union
({{sql_sqlserver_tde_not_encrypted_with_cmek('cis_v1.3.0','0304.09o3Organizational.1 - 09.o - 3')}})
--information_exchange_policies_and_procedures
union
({{web_app_client_cert_disabled('cis_v1.3.0','0662.09sCSPOrganizational.2 - 09.s - 1')}})
union
({{web_cors_should_not_allow_every_resource_to_access_your_web_applications('cis_v1.3.0','0901.09s1Organizational.1 - 09.s - 1')}})
union
({{web_cors_should_not_allow_every_resource_to_access_your_function_apps('cis_v1.3.0','0902.09s2Organizational.13 - 09.s - 1')}})
union
({{web_cors_should_not_allow_every_resource_to_access_your_api_app('cis_v1.3.0','0911.09s1Organizational.2 - 09.s - 1')}})
union
({{web_remote_debugging_should_be_turned_off_for_web_applications('cis_v1.3.0','0912.09s1Organizational.4 - 09.s - 1')}})
union
({{web_remote_debugging_should_be_turned_off_for_function_apps('cis_v1.3.0','0913.09s1Organizational.5 - 09.s - 1')}})
union
({{web_remote_debugging_should_be_turned_off_for_api_apps('cis_v1.3.0','0914.09s1Organizational.6 - 09.s - 1')}})
--on_line_transactions
union
({{storage_secure_transfer_to_storage_accounts_should_be_enabled('cis_v1.3.0','0943.09y1Organizational.1 - 09.y - 1')}})
union
({{redis_only_secure_connections_to_your_azure_cache_for_redis_should_be_enabled('cis_v1.3.0','0946.09y2Organizational.14 - 09.y - 1')}})
union
({{postgresql_enforce_ssl_connection_should_be_enabled_for_postgresql_database_servers('cis_v1.3.0','0947.09y2Organizational.2 - 09.y - 1')}})
union
({{mysql_enforce_ssl_connection_should_be_enabled_for_mysql_database_servers('cis_v1.3.0','0948.09y2Organizational.3 - 09.y - 1')}})
union
({{web_api_app_should_only_be_accessible_over_https('cis_v1.3.0','0949.09y2Organizational.5 - 09.y - 1')}})
union
({{web_function_app_should_only_be_accessible_over_https('cis_v1.3.0','0949.09y2Organizational.5 - 09.y - 2')}})
union
({{web_latest_tls_version_should_be_used_in_your_api_app('cis_v1.3.0','0949.09y2Organizational.5 - 09.y - 3')}})
union
({{web_latest_tls_version_should_be_used_in_your_function_app('cis_v1.3.0','0949.09y2Organizational.5 - 09.y - 4')}})
union
({{web_latest_tls_version_should_be_used_in_your_web_app('cis_v1.3.0','0949.09y2Organizational.5 - 09.y - 1')}})
union
({{web_web_application_should_only_be_accessible_over_https('cis_v1.3.0','0949.09y2Organizational.5 - 09.y - 1')}})
union
({{web_app_client_cert_disabled('cis_v1.3.0','0915.09s2Organizational.2 - 09.s - 1')}})
union
({{web_cors_should_not_allow_every_resource_to_access_your_web_applications('cis_v1.3.0','0916.09s2Organizational.4 - 09.s - 1')}})
union
({{web_cors_should_not_allow_every_resource_to_access_your_function_apps('cis_v1.3.0','0960.09sCSPOrganizational.1 - 09.s - 1')}})
union
({{web_remote_debugging_should_be_turned_off_for_function_apps('cis_v1.3.0','1325.09s1Organizational.3 - 09.s - 1')}})
--control_of_technical_vulnerabilities
union
({{compute_machines_without_vulnerability_assessment_extension('cis_v1.3.0','0709.10m1Organizational.1 - 10.m - 1')}})
union
({{sql_sql_databases_with_unresolved_vulnerability_findings('cis_v1.3.0','0709.10m1Organizational.1 - 10.m - 2')}})
union
({{sql_managed_instances_without_vulnerability_assessments('cis_v1.3.0','0709.10m1Organizational.1 - 10.m - 6')}})
union
({{sql_servers_without_vulnerability_assessments('cis_v1.3.0','0709.10m1Organizational.1 - 10.m - 7')}})
union
({{sql_managed_instances_without_vulnerability_assessments('cis_v1.3.0','0710.10m2Organizational.1 - 10.m')}})
--dup
union
({{compute_machines_without_vulnerability_assessment_extension('cis_v1.3.0','0711.10m2Organizational.23 - 10.m')}})
--dup
union
({{sql_sql_databases_with_unresolved_vulnerability_findings('cis_v1.3.0','0716.10m3Organizational.1 - 10.m - 1')}})
--dup
union
({{sql_managed_instances_without_vulnerability_assessments('cis_v1.3.0','0719.10m3Organizational.5 - 10.m - 1')}})
--dup
--business_continuity_and_risk_assessment
union
({{compute_audit_virtual_machines_without_disaster_recovery_configured('cis_v1.3.0','1634.12b1Organizational.1 - 12.b - 1')}})
union
({{keyvault_azure_key_vault_managed_hsm_should_have_purge_protection_enabled('cis_v1.3.0','1635.12b1Organizational.2 - 12.b - 1')}})
union
({{keyvault_not_recoverable('cis_v1.3.0','1635.12b1Organizational.2 - 12.b - 2')}})
union
({{compute_audit_virtual_machines_without_disaster_recovery_configured('cis_v1.3.0','1638.12b2Organizational.345 - 12.b - 1')}})
--dup
 )
select *
from aggregated

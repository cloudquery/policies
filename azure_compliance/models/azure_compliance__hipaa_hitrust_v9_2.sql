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

 )
select *
from aggregated

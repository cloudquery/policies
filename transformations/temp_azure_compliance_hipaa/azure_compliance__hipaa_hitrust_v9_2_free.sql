with
    aggregated as (
    --User Authentication for External Connections  
    ({{security_mfa_should_be_enabled_on_accounts_with_owner_permissions_on_your_subscription('hipaa_hitrust_v9.2','1116_01j1organizational_145_01_j')}})
    union
    ({{security_mfa_should_be_enabled_accounts_with_write_permissions_on_your_subscription('hipaa_hitrust_v9.2','1117_01j1organizational_23_01_j')}})
    union        
    ({{security_mfa_should_be_enabled_on_accounts_with_read_permissions_on_your_subscription('hipaa_hitrust_v9.2','1118_01j2organizational_124_01_j')}})
    union        
    ({{compute_virtual_machines_without_jit_network_access_policy('hipaa_hitrust_v9.2','1119_01j2organizational_3_01_j')}})
    union
    ({{compute_vms_without_approved_networks('hipaa_hitrust_v9.2','0806.01m2Organizational.12356 - 01.m - 11')}})
    union
    ({{network_subnets_without_nsg_associated('hipaa_hitrust_v9.2','0806.01m2Organizational.12356 - 01.m - 10')}})
    union
    ({{keyvault_vaults_with_no_service_endpoint('hipaa_hitrust_v9.2','0806.01m2Organizational.12356 - 01.m - 7')}})
    union
    ({{compute_internet_facing_virtual_machines_should_be_protected_with_network_security_groups('hipaa_hitrust_v9.2','0806.01m2Organizational.12356 - 01.m - 6')}})
    union 
    ({{eventhub_event_hub_should_use_a_virtual_network_service_endpoint('hipaa_hitrust_v9.2','0806.01m2Organizational.12356 - 01.m - 4')}})
    union
    ({{cosmosdb_cosmos_db_should_use_a_virtual_network_service_endpoint('hipaa_hitrust_v9.2','0806.01m2Organizational.12356 - 01.m - 3')}})
 )
select 
        ('{{ run_started_at }}')::timestamp as policy_execution_time,
        aggregated.*
from aggregated

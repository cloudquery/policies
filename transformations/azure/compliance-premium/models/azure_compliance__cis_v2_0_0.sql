
with
    aggregated as (
        ({{iam_custom_subscription_owner_roles('cis_v2.0.0','1.23')}})
        {{ union() }}
        ({{security_defender_on_for_servers('cis_v2.0.0','2.1')}})
        {{ union() }}
        ({{security_defender_on_for_app_service('cis_v2.0.0','2.2')}})
        {{ union() }}
        ({{security_defender_on_for_databases('cis_v2.0.0','2.3')}}) --note: this policy covers 2.1.6 and 2.1.9
        {{ union() }}
        ({{security_defender_on_for_sql_servers('cis_v2.0.0','2.4')}})
        {{ union() }}
        ({{security_defender_on_for_sql_servers_on_machines('cis_v2.0.0','2.5')}})
        {{ union() }}
        ({{security_defender_on_for_storage('cis_v2.0.0','2.7')}})
        {{ union() }}
        ({{security_defender_on_for_container_registeries('cis_v2.0.0','2.8')}})
        {{ union() }}
        ({{security_defender_on_for_key_vault('cis_v2.0.0','2.10')}})
        {{ union() }}
        ({{security_defender_on_for_dns('cis_v2.0.0','2.11')}})
        {{ union() }}
        ({{security_defender_on_for_resource_manager('cis_v2.0.0','2.12')}})
        {{ union() }}
        ({{security_default_policy_disabled('cis_v2.0.0','2.14')}})
        {{ union() }}
        ({{security_auto_provisioning_monitoring_agent_enabled('cis_v2.0.0','2.15')}})
        {{ union() }}
        ({{security_emails_on_for_owner_role('cis_v2.0.0','2.18')}})
        {{ union() }}
        ({{security_additional_security_email_configured('cis_v2.0.0','2.19')}})
        {{ union() }}
        ({{security_notify_high_severity_alerts('cis_v2.0.0','2.20')}})
        {{ union() }}
        ({{storage_secure_transfer_to_storage_accounts_should_be_enabled('cis_v2.0.0','3.1')}})
        {{ union() }}
        ({{storage_infrastructure_encryption_enabled('cis_v2.0.0','3.2')}})
        {{ union() }}
        ({{storage_no_public_blob_container('cis_v2.0.0','3.7')}})
        {{ union() }}
        ({{storage_default_network_access_rule_is_deny('cis_v2.0.0','3.8')}})
        {{ union() }}
        ({{storage_soft_delete_is_enabled('cis_v2.0.0','3.11')}})
        {{ union() }}
        ({{storage_encrypt_with_cmk('cis_v2.0.0','3.12')}})
        {{ union() }}
        ({{sql_auditing_off('cis_v2.0.0','4.1.1')}})
        {{ union() }}
        ({{sql_no_sql_allow_ingress_from_any_ip('cis_v2.0.0','4.1.2')}})
        {{ union() }}
        ({{sql_sqlserver_tde_not_encrypted_with_cmek('cis_v2.0.0','4.1.3')}})
        {{ union() }}
        ({{sql_ad_admin_configured('cis_v2.0.0','4.1.4')}})
        {{ union() }}
        ({{sql_data_encryption_off('cis_v2.0.0','4.1.5')}})
        {{ union() }}
        ({{sql_auditing_retention_less_than_90_days('cis_v2.0.0','4.1.6')}})
        {{ union() }}
        ({{sql_atp_on_sql_server_disabled('cis_v2.0.0','4.2.1')}}) --atp is now windows defender
        {{ union() }}
        ({{sql_va_is_enabled_on_sql_server_by_storage_account('cis_v2.0.0','4.2.2')}})
        {{ union() }}
        ({{sql_va_periodic_scans_enabled_on_sql_server('cis_v2.0.0','4.2.3')}})
        {{ union() }}
        ({{sql_va_send_scan_report_enabled_on_sql_server('cis_v2.0.0','4.2.4')}})
        {{ union() }}
        ({{sql_va_send_email_to_admins_and_owners_enabled('cis_v2.0.0','4.2.5')}})
        {{ union() }}
        ({{sql_postgresql_ssl_enforcment_disabled('cis_v2.0.0','4.3.1')}})
        {{ union() }}
        ({{sql_postgresql_log_checkpoints_disabled('cis_v2.0.0','4.3.2')}})
        {{ union() }}
        ({{sql_postgresql_log_connections_disabled('cis_v2.0.0','4.3.3')}})
        {{ union() }}
        ({{sql_postgresql_log_disconnections_disabled('cis_v2.0.0','4.3.4')}})
        {{ union() }}
        ({{sql_postgresql_connection_throttling_disabled('cis_v2.0.0','4.3.5')}})
        {{ union() }}
        ({{sql_postgresql_log_retention_days_less_than_3_days('cis_v2.0.0','4.3.6')}})
        {{ union() }}
        ({{sql_postgresql_allow_access_to_azure_services_enabled('cis_v2.0.0','4.3.7')}})
        {{ union() }}
        ({{sql_postgresql_infrastructure_double_encryption('cis_v2.0.0','4.3.8')}})
        {{ union() }}
        ({{sql_ad_admin_configured('cis_v2.0.0','4.4')}})
        {{ union() }}
        ({{sql_mysql_ssl_enforcment_disabled('cis_v2.0.0','4.4.1')}})
        {{ union() }}
        ({{sql_mysql_tls_v_1_2_set('cis_v2.0.0','4.4.2')}})
        {{ union() }}
        ({{sql_mysql_audit_log_enabled('cis_v2.0.0','4.4.3')}})
        {{ union() }}
        ({{sql_mysql_audit_log_events_include_connection('cis_v2.0.0','4.4.4')}})
        {{ union() }}
        ({{sql_sqlserver_tde_not_encrypted_with_cmek('cis_v2.0.0','4.5')}})
        {{ union() }}
        ({{monitor_no_diagnostic_setting('cis_v2.0.0','5.1.1')}})
        {{ union() }}
        ({{monitor_insufficient_diagnostic_capturing_settings('cis_v2.0.0','5.1.2')}})
        {{ union() }}
        ({{storage_no_publicly_accessible_insights_activity_logs('cis_v2.0.0','5.1.3')}})
        {{ union() }}
        ({{storage_encrypt_with_cmk_for_activity_log('cis_v2.0.0','5.1.4')}})
        {{ union() }}
        ({{monitor_logging_key_vault_is_enabled('cis_v2.0.0','5.1.5')}})
        {{ union() }}
        ({{monitor_log_alert_for_create_policy_assignment('cis_v2.0.0','5.2.1')}})
        {{ union() }}
        ({{monitor_log_alert_for_delete_policy_assignment('cis_v2.0.0','5.2.2')}})
        {{ union() }}
        ({{monitor_log_alert_for_create_or_update_network_sg('cis_v2.0.0','5.2.3')}})
        {{ union() }}
        ({{monitor_log_alert_for_delete_network_sg('cis_v2.0.0','5.2.4')}})
        {{ union() }}
        ({{monitor_log_alert_for_create_or_update_security_solution('cis_v2.0.0','5.2.5')}})
        {{ union() }}
        ({{monitor_log_alert_for_delete_security_solution('cis_v2.0.0','5.2.6')}})
        {{ union() }}
        ({{monitor_log_alert_for_create_or_update_sql_server_firewall_rule('cis_v2.0.0','5.2.7')}})
        {{ union() }}
        ({{monitor_log_alert_for_delete_sql_server_firewall_rule('cis_v2.0.0','5.2.8')}})
        {{ union() }}
        ({{monitor_log_alert_for_create_or_update_public_ip_address_rule('cis_v2.0.0','5.2.9')}})
        {{ union() }}
        ({{monitor_log_alert_for_delete_public_ip_address_rule('cis_v2.0.0','5.2.10')}})
        {{ union() }}
        ({{monitor_web_application_insights_configured('cis_v2.0.0','5.3.1')}})
        {{ union() }}
        ({{monitor_diagnostic_logs_for_all_services('cis_v2.0.0','5.4')}})
        {{ union() }}
        ({{monitor_basic_or_consumption_sku_not_used('cis_v2.0.0','5.5')}})
        {{ union() }}
        ({{network_rdp_services_are_restricted_from_the_internet('cis_v2.0.0','6.1')}})
        {{ union() }}
        ({{network_ssh_services_are_restricted_from_the_internet('cis_v2.0.0','6.2')}})
        {{ union() }}
        ({{sql_no_sql_allow_ingress_from_any_ip('cis_v2.0.0','6.3')}})
        {{ union() }}
        ({{network_nsg_log_retention_period('cis_v2.0.0','6.4')}})
        {{ union() }}
        ({{network_udp_services_are_restricted_from_the_internet('cis_v2.0.0','6.6')}})
        {{ union() }}
        ({{compute_vms_utilizing_managed_disks('cis_v2.0.0','7.1')}})
        {{ union() }}
        ({{compute_os_and_data_disks_encrypted_with_cmk('cis_v2.0.0','7.2')}})
        {{ union() }}
        ({{compute_unattached_disks_are_encrypted_with_cmk('cis_v2.0.0','7.3')}})
        {{ union() }}
        ({{compute_vhds_not_encrypted('cis_v2.0.0','7.7')}})
        {{ union() }}
        ({{keyvault_keys_without_expiration_date('cis_v2.0.0','8.1')}})
        {{ union() }}
        ({{keyvault_secrets_without_expiration_date('cis_v2.0.0','8.2')}})
        {{ union() }}
        ({{keyvault_not_recoverable('cis_v2.0.0','8.4')}})
        {{ union() }}
        ({{container_aks_rbac_disabled('cis_v2.0.0','8.5')}})
        {{ union() }}
        ({{web_app_auth_unset('cis_v2.0.0','9.1')}})
        {{ union() }}
        ({{web_app_allow_http('cis_v2.0.0','9.2')}})
        {{ union() }}
        ({{web_app_using_old_tls('cis_v2.0.0','9.3')}})
        {{ union() }}
        ({{web_app_client_cert_disabled('cis_v2.0.0','9.4')}})
        {{ union() }}
        ({{web_app_register_with_ad_disabled('cis_v2.0.0','9.5')}})
        {{ union() }}
        ({{web_app_ftp_deployment_enabled('cis_v2.0.0','9.10')}})

 )
select 
        {{ gen_timestamp() }},
        aggregated.*
from aggregated


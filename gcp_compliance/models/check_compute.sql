with
    aggregated as (
        {{ compute_default_network_exist('cis_v1.2.0', '3.1') }}
        union
        {{ compute_legacy_network_exist('cis_v1.2.0', '3.2') }}
        union
        {{ compute_ssh_access_permitted('cis_v1.2.0', '3.6') }}
        union
        {{ compute_rdp_access_permitted('cis_v1.2.0', '3.7') }}
        union
        {{ compute_flow_logs_disabled_in_vpc('cis_v1.2.0', '3.8') }}
        union
        {{ compute_ssl_proxy_with_weak_cipher('cis_v1.2.0', '3.9') }}
        union
        {{ compute_instances_with_default_service_account('cis_v1.2.0', '4.1') }}
        union
        {{ compute_instances_with_default_service_account_with_full_access('cis_v1.2.0', '4.2') }}
        union
        {{ compute_instances_without_block_project_wide_ssh_keys('cis_v1.2.0', '4.3') }}
        union
        {{ compute_oslogin_disabled('cis_v1.2.0', '4.4') }}
        union
        {{ compute_serial_port_connection_enabled('cis_v1.2.0', '4.5') }}
        union
        {{ compute_disks_encrypted_with_csek('cis_v1.2.0', '4.7') }}
        union
        {{ compute_instances_with_shielded_vm_disabled('cis_v1.2.0', '4.8') }}
        union
        {{ compute_instances_with_public_ip('cis_v1.2.0', '4.9') }}
        union
        {{ compute_instances_without_confidential_computing('cis_v1.2.0', '4.11') }}
    )

select * from aggregated

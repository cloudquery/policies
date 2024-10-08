with
    aggregated as (
    ({{ alarm_unauthorized_api('cis_v1.2.0','3.1') }})
        {{ union() }}
    ({{ alarm_root_account('cis_v1.2.0','3.3') }})
        {{ union() }}
    ({{ alarm_iam_policy_change('cis_v1.2.0','3.4') }})
        {{ union() }}
    ({{ alarm_cloudtrail_config_changes('cis_v1.2.0','3.5') }})
        {{ union() }}
    ({{ alarm_console_auth_failure('cis_v1.2.0','3.6') }})
        {{ union() }}
    ({{ alarm_delete_customer_cmk('cis_v1.2.0','3.7') }})
        {{ union() }}
    ({{ alarm_s3_bucket_policy_change('cis_v1.2.0','3.8') }})
        {{ union() }}
    ({{ alarm_aws_config_changes('cis_v1.2.0','3.9') }})
        {{ union() }}
    ({{ alarm_security_group_changes('cis_v1.2.0','3.10') }})
        {{ union() }}
    ({{ alarm_nacl_changes('cis_v1.2.0','3.11') }})
        {{ union() }}
    ({{ alarm_network_gateways('cis_v1.2.0','3.12') }})
        {{ union() }}
    ({{ alarm_route_table_changes('cis_v1.2.0','3.13') }})
        {{ union() }}
    ({{ alarm_vpc_changes('cis_v1.2.0','3.14') }})
        {{ union() }}
    ({{ cloudtrail_enabled_all_regions('cis_v1.2.0','2.1') }})
        {{ union() }}
    ({{ log_file_validation_enabled('cis_v1.2.0','2.2') }})
        {{ union() }}
    ({{ integrated_with_cloudwatch_logs('cis_v1.2.0','2.4') }})
        {{ union() }}
    ({{ bucket_access_logging('cis_v1.2.0','2.6') }})
        {{ union() }}
    ({{ logs_encrypted('cis_v1.2.0','2.7') }})
        {{ union() }}
    ({{ rotation_enabled_for_customer_key('cis_v1.2.0','2.8') }})
        {{ union() }}
    ({{ flow_logs_enabled_in_all_vpcs('cis_v1.2.0','2.9') }})
        {{ union() }}
    ({{ avoid_root_usage('cis_v1.2.0','1.1') }})
        {{ union() }}
    ({{ mfa_enabled_for_console_access('cis_v1.2.0','1.2') }})
        {{ union() }}
    ({{ unused_creds_disabled('cis_v1.2.0','1.3') }})
        {{ union() }}
    ({{ old_access_keys('cis_v1.2.0','1.4') }})
        {{ union() }}
    ({{ password_policy_min_uppercase('cis_v1.2.0','1.5') }})
        {{ union() }}
    ({{ password_policy_min_lowercase('cis_v1.2.0','1.6') }})
        {{ union() }}
    ({{ password_policy_min_one_symbol('cis_v1.2.0','1.7') }})
        {{ union() }}
    ({{ password_policy_min_number('cis_v1.2.0','1.8') }})
        {{ union() }}
    ({{ password_policy_min_length('cis_v1.2.0','1.9') }})
        {{ union() }}
    ({{ password_policy_prevent_reuse('cis_v1.2.0','1.10') }})
        {{ union() }}
    ({{ password_policy_expire_old_passwords('cis_v1.2.0','1.11') }})
        {{ union() }}
    ({{ root_user_no_access_keys('cis_v1.2.0','1.12') }})
        {{ union() }}
    ({{ mfa_enabled_for_root('cis_v1.2.0','1.13') }})
        {{ union() }}
    ({{ hardware_mfa_enabled_for_root('cis_v1.2.0','1.14') }})
        {{ union() }}
    ({{ policies_attached_to_groups_roles('cis_v1.2.0','1.16') }})
        {{ union() }}
    ({{ no_broad_public_ingress_on_port_22('cis_v1.2.0','4.1') }})
        {{ union() }}
    ({{ no_broad_public_ingress_on_port_3389('cis_v1.2.0','4.2') }})
        {{ union() }}
    ({{ default_sg_no_access('cis_v1.2.0','4.3') }})
    )
select 
        {{ gen_timestamp() }},
        aggregated.*
from aggregated

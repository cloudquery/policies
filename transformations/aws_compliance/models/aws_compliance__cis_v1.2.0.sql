with
    aggregated as (
    ({{ alarm_unauthorized_api('cis_v1.2.0','3.1') }})
        UNION
    ({{ alarm_root_account('cis_v1.2.0','3.3') }})
        UNION
    ({{ alarm_iam_policy_change('cis_v1.2.0','3.4') }})
        UNION
    ({{ alarm_cloudtrail_config_changes('cis_v1.2.0','3.5') }})
        UNION
    ({{ alarm_console_auth_failure('cis_v1.2.0','3.6') }})
        UNION
    ({{ alarm_delete_customer_cmk('cis_v1.2.0','3.7') }})
        UNION
    ({{ alarm_s3_bucket_policy_change('cis_v1.2.0','3.8') }})
        UNION
    ({{ alarm_aws_config_changes('cis_v1.2.0','3.9') }})
        UNION
    ({{ alarm_security_group_changes('cis_v1.2.0','3.10') }})
        UNION
    ({{ alarm_nacl_changes('cis_v1.2.0','3.11') }})
        UNION
    ({{ alarm_network_gateways('cis_v1.2.0','3.12') }})
        UNION
    ({{ alarm_route_table_changes('cis_v1.2.0','3.13') }})
        UNION
    ({{ alarm_vpc_changes('cis_v1.2.0','3.14') }})
        UNION
    ({{ enabled_in_all_regions('cis_v1.2.0','2.1') }})
        UNION
    ({{ log_file_validation_enabled('cis_v1.2.0','2.2') }})
        UNION
    ({{ integrated_with_cloudwatch_logs('cis_v1.2.0','2.4') }})
        UNION
    ({{ bucket_access_logging('cis_v1.2.0','2.6') }})
        UNION
    ({{ logs_encrypted('cis_v1.2.0','2.7') }})
        UNION
    ({{ rotation_enabled_for_customer_key('cis_v1.2.0','2.8') }})
        UNION
    ({{ flow_logs_enabled_in_all_vpcs('cis_v1.2.0','2.9') }})
        UNION
    ({{ avoid_root_usage('cis_v1.2.0','1.1') }})
        UNION
    ({{ mfa_enabled_for_console_access('cis_v1.2.0','1.2') }})
        UNION
    ({{ unused_creds_disabled('cis_v1.2.0','1.3') }})
        UNION
    ({{ old_access_keys('cis_v1.2.0','1.4') }})
        UNION
    ({{ password_policy_min_uppercase('cis_v1.2.0','1.5') }})
        UNION
    ({{ password_policy_min_lowercase('cis_v1.2.0','1.6') }})
        UNION
    ({{ password_policy_min_one_symbol('cis_v1.2.0','1.7') }})
        UNION
    ({{ password_policy_min_number('cis_v1.2.0','1.8') }})
        UNION
    ({{ password_policy_min_length('cis_v1.2.0','1.9') }})
        UNION
    ({{ password_policy_prevent_reuse('cis_v1.2.0','1.10') }})
        UNION
    ({{ password_policy_expire_old_passwords('cis_v1.2.0','1.11') }})
        UNION
    ({{ root_user_no_access_keys('cis_v1.2.0','1.12') }})
        UNION
    ({{ mfa_enabled_for_root('cis_v1.2.0','1.13') }})
        UNION
    ({{ hardware_mfa_enabled_for_root('cis_v1.2.0','1.14') }})
        UNION
    ({{ policies_attached_to_groups_roles('cis_v1.2.0','1.16') }})
        UNION
    ({{ no_broad_public_ingress_on_port_22('cis_v1.2.0','4.1') }})
        UNION
    ({{ no_broad_public_ingress_on_port_3389('cis_v1.2.0','4.2') }})
        UNION
    ({{ default_sg_no_access('cis_v1.2.0','4.3') }})
    )
select 
*
from aggregated

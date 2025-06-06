with
    aggregated as (
        ({{ autoscaling_groups_elb_check('pci_dss_v3.2.1','autoscaling.1') }})
        {{ union() }}
        ({{ logs_encrypted('pci_dss_v3.2.1','cloudtrail.1') }})
        {{ union() }}
        ({{ cloudtrail_enabled_all_regions('pci_dss_v3.2.1','cloudtrail.2') }})
        {{ union() }}
        ({{ log_file_validation_enabled('pci_dss_v3.2.1','cloudtrail.3') }})
        {{ union() }}
        ({{ integrated_with_cloudwatch_logs('pci_dss_v3.2.1','cloudtrail.4') }})
        {{ union() }}
        ({{ cloudtrail_enabled('pci_dss_v3.2.1','cloudtrail.5') }})
        {{ union() }}
        ({{ check_oauth_usage_for_sources('pci_dss_v3.2.1','codebuild.1') }})
        {{ union() }}
        ({{ check_environment_variables('pci_dss_v3.2.1','codebuild.2') }})
        {{ union() }}
        ({{ config_enabled_all_regions('pci_dss_v3.2.1','config.1') }})
        {{ union() }}
        ({{ alarm_root_account('pci_dss_v3.2.1','cloudwatch.1') }})
        {{ union() }}
        ({{ replication_not_public('pci_dss_v3.2.1','dms.1') }})
        {{ union() }}
        ({{ ebs_snapshot_permissions_check('pci_dss_v3.2.1','ec2.1') }})
        {{ union() }}
        ({{ default_sg_no_access('pci_dss_v3.2.1','ec2.2') }})
        {{ union() }}
        ({{ get_unused_public_ips('pci_dss_v3.2.1','ec2.4') }})
        {{ union() }}
        ({{ no_broad_public_ingress_on_port_22('pci_dss_v3.2.1','ec2.5') }})
        {{ union() }}
        ({{ flow_logs_enabled_in_all_vpcs('pci_dss_v3.2.1','ec2.6') }})
        {{ union() }}
        ({{ elbv2_redirect_http_to_https('pci_dss_v3.2.1','elbv2.1') }})
        {{ union() }}
        ({{ elasticsearch_domains_should_be_in_vpc('pci_dss_v3.2.1','elasticsearch.1') }})
        {{ union() }}
        ({{ elasticsearch_domains_should_have_encryption_at_rest_enabled('pci_dss_v3.2.1','elasticsearch.2') }})
        {{ union() }}
        ({{ detector_enabled('pci_dss_v3.2.1','guardduty enabled in all enabled regions') }})
        {{ union() }}
        ({{ root_user_no_access_keys('pci_dss_v3.2.1','iam.1') }})
        {{ union() }}
        ({{ policies_attached_to_groups_roles('pci_dss_v3.2.1','iam.2') }})
        {{ union() }}
        ({{ no_star('pci_dss_v3.2.1','iam.3') }})
        {{ union() }}
        ({{ hardware_mfa_enabled_for_root('pci_dss_v3.2.1','iam.4') }})
        {{ union() }}
        ({{ mfa_enabled_for_root('pci_dss_v3.2.1','iam.5') }})
        {{ union() }}
        ({{ mfa_enabled_for_console_access('pci_dss_v3.2.1','iam.6') }})
        {{ union() }}
        ({{ unused_creds_disabled('pci_dss_v3.2.1','iam.7') }})
        {{ union() }}
        ({{ password_policy_strong('pci_dss_v3.2.1','iam.8') }})
        {{ union() }}
        ({{ rotation_enabled_for_customer_key('pci_dss_v3.2.1','kms.1') }})
        {{ union() }}
        ({{ lambda_function_prohibit_public_access('pci_dss_v3.2.1','lambda.1') }})
        {{ union() }}
        ({{ lambda_function_in_vpc('pci_dss_v3.2.1','lambda.2') }})
        {{ union() }}
        ({{ snapshots_should_prohibit_public_access('pci_dss_v3.2.1','rds.1') }})
        {{ union() }}
        ({{ rds_db_instances_should_prohibit_public_access('pci_dss_v3.2.1','rds.2') }})
        {{ union() }}
        ({{ cluster_publicly_accessible('pci_dss_v3.2.1','redshift.1') }})
        {{ union() }}
        ({{ publicly_writable_buckets('pci_dss_v3.2.1','s3.1') }})
        {{ union() }}
        ({{ publicly_readable_buckets('pci_dss_v3.2.1','s3.2') }})
        {{ union() }}
        ({{ s3_cross_region_replication('pci_dss_v3.2.1','s3.3') }})
        {{ union() }}
        ({{ deny_http_requests('pci_dss_v3.2.1','s3.5') }})
        {{ union() }}
        ({{ account_level_public_access_blocks('pci_dss_v3.2.1','s3.6') }})
        {{ union() }}
        ({{ sagemaker_notebook_instance_direct_internet_access_disabled('pci_dss_v3.2.1','sagemaker.1') }})
        {{ union() }}
        ({{ secrets_should_have_automatic_rotation_enabled('pci_dss_v3.2.1','secretmanager.1') }})
        {{ union() }}
        ({{ secrets_configured_with_automatic_rotation_should_rotate_successfully('pci_dss_v3.2.1','secretmanager.2') }})
        {{ union() }}
        ({{ remove_unused_secrets_manager_secrets('pci_dss_v3.2.1','secretmanager.3') }})
        {{ union() }}
        ({{ secrets_should_be_rotated_within_a_specified_number_of_days('pci_dss_v3.2.1','secretmanager.4') }})
        {{ union() }}
        ({{ instances_should_have_patch_compliance_status_of_compliant('pci_dss_v3.2.1','ssm.1') }})
        {{ union() }}
        ({{ instances_should_have_association_compliance_status_of_compliant('pci_dss_v3.2.1','ssm.2') }})
        {{ union() }}
        ({{ ec2_instances_should_be_managed_by_ssm('pci_dss_v3.2.1','ssm.3') }})
        {{ union() }}
        ({{ wafv2_web_acl_logging_should_be_enabled('pci_dss_v3.2.1','waf.1') }})    
    )
select 
        {{ gen_timestamp() }},
        aggregated.*
from aggregated


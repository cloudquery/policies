{{ config(enabled=block_bigquery() and block_postgres()) }}

with
    aggregated as (
        ({{ access_logs_enabled('foundational_security','cloudfront.5') }})
        union
        ({{ access_point_enforce_user_identity('foundational_security','efs.4') }})
        union
        ({{ access_point_path_should_not_be_root('foundational_security','efs.3') }})
        union
        ({{ account_level_public_access_blocks('foundational_security','s3.1') }})
        union
        ({{ advanced_health_reporting_enabled('foundational_security','elastic_beanstalk.1') }})
        union
        ({{ alb_deletion_protection_enabled('foundational_security','elb.6') }})
        union
        ({{ alb_drop_http_headers('foundational_security','elb.4') }})
        union
        ({{ alb_logging_enabled('foundational_security','elb.5') }})
        union
        ({{ amazon_aurora_clusters_should_have_backtracking_enabled('foundational_security','rds.14') }})
        union
        ({{ api_gw_access_logging_should_be_configured('foundational_security','apigateway.9') }})
        union
        ({{ api_gw_associated_wth_waf('foundational_security','apigateway.4') }})
        union
        ({{ api_gw_cache_data_encrypted('foundational_security','apigateway.5') }})
        union
        ({{ api_gw_execution_logging_enabled('foundational_security','apigateway.1') }})
        union
        ({{ api_gw_routes_should_specify_authorization_type('foundational_security','apigateway.8') }})
        union
        ({{ api_gw_stage_should_have_xray_tracing_enabled('foundational_security','apigateway.3') }})
        union
        ({{ api_gw_stage_should_use_ssl('foundational_security','apigateway.2') }})
        union
        ({{ appsync_should_have_logging_turned_on('foundational_security','appsync.2') }})
        union
        ({{ associated_with_waf('foundational_security','cloudfront.6') }})
        union
        ({{ athena_workgroup_encrypted_at_rest('foundational_security','athena.1') }})
        union
        ({{ autoscale_or_ondemand('foundational_security','dynamodb.1') }})
        union
        ({{ autoscaling_group_elb_healthcheck_required('foundational_security','autoscaling.1') }})
        union
        ({{ autoscaling_launch_config_hop_limit('foundational_security','autoscaling.4') }})
        union
        ({{ autoscaling_launch_config_public_ip_disabled('foundational_security','autoscaling.5') }})
        union
        ({{ autoscaling_launch_template('foundational_security','autoscaling.9') }})
        union
        ({{ autoscaling_launchconfig_requires_imdsv2('foundational_security','autoscaling.3') }})
        union
        ({{ autoscaling_multiple_az('foundational_security','autoscaling.2') }})
        union
        ({{ autoscaling_multiple_instance_types('foundational_security','autoscaling.6') }})
        union
        ({{ both_vpn_channels_should_be_up('foundational_security','ec2.20') }})
        union
        ({{ certificates_should_be_renewed('foundational_security','acm.1') }})
        union
        ({{ check_environment_variables('foundational_security','codebuild.2') }})
        union
        ({{ check_oauth_usage_for_sources('foundational_security','codebuild.1') }})
        union
        ({{ cloudformation_stack_notification_check('foundational_security','cloudformation.1') }})
        union
        ({{ cluster_endpoints_not_publicly_accessible('foundational_security','eks.1') }})
        union
        ({{ cluster_publicly_accessible('foundational_security','redshift.1') }})
        union
        ({{ cluster_snapshots_and_database_snapshots_should_be_encrypted_at_rest('foundational_security','rds.4') }})
        union
        ({{ clusters_should_be_configured_for_multiple_availability_zones('foundational_security','rds.15') }})
        union
        ({{ clusters_should_be_configured_to_copy_tags_to_snapshots('foundational_security','rds.16') }})
        union
        ({{ clusters_should_be_encrypted_at_rest('foundational_security','documentdb.1') }})
        union
        ({{ clusters_should_be_encrypted_in_transit('foundational_security','redshift.2') }})
        union
        ({{ clusters_should_have_7_days_backup_retention('foundational_security','documentdb.2') }})
        union
        ({{ clusters_should_have_audit_logging_enabled('foundational_security','redshift.4') }})
        union
        ({{ clusters_should_have_automatic_snapshots_enabled('foundational_security','redshift.3') }})
        union
        ({{ clusters_should_have_automatic_upgrades_to_major_versions_enabled('foundational_security','redshift.6') }})
        union
        ({{ clusters_should_have_deletion_protection_enabled('foundational_security','rds.7') }})
        union
        ({{ clusters_should_not_use_default_subnet_group('foundational_security','elasticache.7') }})
        union
        ({{ clusters_should_run_on_supported_kuberneters_version('foundational_security','eks.2') }})
        union
        ({{ clusters_should_use_container_insights('foundational_security','ecs.12') }})
        union
        ({{ clusters_should_use_enhanced_vpc_routing('foundational_security','redshift.7') }})
        union
        ({{ connections_to_elasticsearch_domains_should_be_encrypted_using_tls_1_2('foundational_security','elastic_search.8') }})
        union
        ({{ containers_limited_read_only_root_filesystems('foundational_security','ecs.5') }})
        union
        ({{ containers_should_run_as_non_privileged('foundational_security','ecs.4') }})
        union
        ({{ database_logging_should_be_enabled('foundational_security','rds.9') }})
        union
        ({{ databases_and_clusters_should_not_use_database_engine_default_port('foundational_security','rds.23') }})
        union
        ({{ dax_encrypted_at_rest('foundational_security','dynamodb.3') }})
        union
        ({{ db_instance_backup_enabled('foundational_security','rds.11') }})
        union
        ({{ default_root_object_configured('foundational_security','cloudfront.1') }})
        union
        ({{ default_sg_no_access('foundational_security','ec2.2') }})
        union
        ({{ deny_http_requests('foundational_security','s3.5') }})
        union
        ({{ detector_enabled('foundational_security','guarddury.1') }})
        union
        ({{ distribution_should_encrypt_traffic_to_custom_origins('foundational_security','cloudfront.9') }})
        union
        ({{ distribution_should_not_point_to_non_existent_s3_origins('foundational_security','cloudfront.12') }})
        union
        ({{ distribution_should_not_use_depricated_ssl_protocols('foundational_security','cloudfront.10') }})
        union
        ({{ distribution_should_use_origin_access_control('foundational_security','cloudfront.13') }})
        union
        ({{ distribution_should_use_sni('foundational_security','cloudfront.8') }})
        union
        ({{ distribution_should_use_ssl_tls_certificates('foundational_security','cloudfront.7') }})
        union
        ({{ documents_should_not_be_public('foundational_security','ssm.4') }})
        union
        ({{ ebs_encryption_by_default_disabled('foundational_security','ec2.7') }})
        union
        ({{ ebs_snapshot_permissions_check('foundational_security','ec2.1') }})
        union
        ({{ ec2_instances_should_be_managed_by_ssm('foundational_security','ssm.1') }})
        union
        ({{ ecs_services_with_public_ips('foundational_security','ecs.2') }})
        union
        ({{ efs_filesystems_with_disabled_backups('foundational_security','efs.2') }})
        union
        ({{ elastic_beanstalk_managed_updates_enabled('foundational_security','elastic_beanstalk.2') }})
        union
        ({{ elastic_beanstalk_stream_logs_to_cloudwatch('foundational_security','elastic_beanstalk.3') }})
        union
        ({{ elasticsearch_domain_error_logging_to_cloudwatch_logs_should_be_enabled('foundational_security','elastic_search.4') }})
        union
        ({{ elasticsearch_domains_should_be_configured_with_at_least_three_dedicated_master_nodes('foundational_security','elastic_search.7') }})
        union
        ({{ elasticsearch_domains_should_be_in_vpc('foundational_security','elastic_search.2') }})
        union
        ({{ elasticsearch_domains_should_encrypt_data_sent_between_nodes('foundational_security','elastic_search.3') }})
        union
        ({{ elasticsearch_domains_should_have_at_least_three_data_nodes('foundational_security','elastic_search.6') }})
        union
        ({{ elasticsearch_domains_should_have_audit_logging_enabled('foundational_security','elastic_search.5') }})
        union
        ({{ elasticsearch_domains_should_have_encryption_at_rest_enabled('foundational_security','elastic_search.1') }})
        union
        ({{ elbv1_cert_provided_by_acm('foundational_security','elb.2') }})
        union
        ({{ elbv1_conn_draining_enabled('foundational_security','elb.7') }})
        union
        ({{ elbv1_desync_migration_mode_defensive_or_strictest('foundational_security','elb.14') }})
        union
        ({{ elbv1_have_cross_zone_load_balancing('foundational_security','elb.9') }})
        union
        ({{ elbv1_have_multiple_availability_zones('foundational_security','elb.10') }})
        union
        ({{ elbv1_https_or_tls('foundational_security','elb.3') }})
        union
        ({{ elbv1_https_predefined_policy('foundational_security','elb.8') }})
        union
        ({{ elbv2_desync_migration_mode_defensive_or_strictest('foundational_security','elbv2.12') }})
        union
        ({{ elbv2_have_multiple_availability_zones('foundational_security','elbv2.13') }})
        union
        ({{ elbv2_redirect_http_to_https('foundational_security','elbv2.1') }})
        union
        ({{ emr_cluster_master_nodes_should_not_have_public_ip_addresses('foundational_security','emr.1') }})
        union
        ({{ config_enabled_all_regions('foundational_security','awsconfig.1') }})
        union
        ({{ cloudtrail_enabled_all_regions('foundational_security','cloudtrail.1') }})
        union
        ({{ enhanced_monitoring_should_be_configured_for_instances_and_clusters('foundational_security','rds.6') }})
        union
        ({{ fargate_should_run_on_latest_version('foundational_security','ecs.10') }})
        union
        ({{ flow_logs_enabled_in_all_vpcs('foundational_security','ec2.6') }})
        union
        ({{ hardware_mfa_enabled_for_root('foundational_security','iam.6') }})
        union
        ({{ iam_access_keys_rotated_more_than_90_days('foundational_security','iam.3') }})
        union
        ({{ iam_access_keys_rotated_more_than_90_days('foundational_security','iam.8') }})
        union
        ({{ iam_authentication_should_be_configured_for_rds_clusters('foundational_security','rds.12') }})
        union
        ({{ iam_authentication_should_be_configured_for_rds_instances('foundational_security','rds.10') }})
        union
        ({{ iam_customer_policy_no_kms_decrypt('foundational_security','kms.1') }})
        union
        ({{ iam_inline_policy_no_kms_decrypt('foundational_security','kms.2') }})
        union
        ({{ instances_should_be_configured_to_copy_tags_to_snapshots('foundational_security','rds.17') }})
        union
        ({{ instances_should_be_configured_with_multiple_azs('foundational_security','rds.5') }})
        union
        ({{ instances_should_be_deployed_in_a_vpc('foundational_security','rds.18') }})
        union
        ({{ instances_should_have_association_compliance_status_of_compliant('foundational_security','ssm.3') }})
        union
        ({{ instances_should_have_deletion_protection_enabled('foundational_security','rds.8') }})
        union
        ({{ instances_should_have_ecnryption_at_rest_enabled('foundational_security','rds.3') }})
        union
        ({{ instances_should_have_patch_compliance_status_of_compliant('foundational_security','ssm.2') }})
        union
        ({{ instances_should_prohibit_public_access('foundational_security','rds.2') }})
        union
        ({{ instances_with_more_than_2_network_interfaces('foundational_security','ec2.17') }})
        union
        ({{ instances_with_public_ip('foundational_security','ec2.9') }})
        union
        ({{ integrated_with_cloudwatch_logs('foundational_security','cloudtrail.5') }})
        union
        ({{ key_rotation_enabled('foundational_security','kms.4') }})
        union
        ({{ keys_not_unintentionally_deleted('foundational_security','kms.3') }})
        union
        ({{ kinesis_stream_encrypted('foundational_security','kinesis') }})
        union
        ({{ lambda_function_public_access_prohibited('foundational_security','lambda.1') }})
        union
        ({{ lambda_functions_should_use_supported_runtimes('foundational_security','lambda.2') }})
        union
        ({{ lambda_inside_vpc('foundational_security','lambda.3') }})
        union
        ({{ lambda_vpc_multi_az_check('foundational_security','lambda.5') }})
        union
        ({{ launch_templates_should_not_assign_public_ip('foundational_security','ec2.25') }})
        union
        ({{ logs_encrypted('foundational_security','cloudtrail.2') }})
        union
        ({{ logs_file_validation_enabled('foundational_security','cloudtrail.3') }})
        union
        ({{ logs_file_validation_enabled('foundational_security','cloudtrail.4') }})
        union
        ({{ mfa_enabled_for_console_access('foundational_security','iam.5') }})
        union
        ({{ neptune_cluster_backup_retention_check('foundational_security','neptune.5') }})
        union
        ({{ neptune_cluster_cloudwatch_log_export_enabled('foundational_security','neptune.2') }})
        union
        ({{ neptune_cluster_copy_tags_to_snapshot_enabled('foundational_security','neptune.8') }})
        union
        ({{ neptune_cluster_deletion_protection_enabled('foundational_security','neptune.4') }})
        union
        ({{ neptune_cluster_encrypted('foundational_security','neptune.1') }})
        union
        ({{ neptune_cluster_iam_database_authentication('foundational_security','neptune.7') }})
        union
        ({{ neptune_cluster_snapshot_encrypted('foundational_security','neptune.6') }})
        union
        ({{ neptune_cluster_snapshot_public_prohibited('foundational_security','neptune.3') }})
        union
        ({{ netfw_policy_default_action_fragment_packets('foundational_security','networkfirewall.5') }})
        union
        ({{ netfw_policy_default_action_full_packets('foundational_security','networkfirewall.4') }})
        union
        ({{ netfw_policy_rule_group_associated('foundational_security','networkfirewall.3') }})
        union
        ({{ netfw_stateless_rule_group_not_empty('foundational_security','networkfirewall.6') }})
        union
        ({{ network_acls_should_not_allow_ingress_for_ssh_rdp_ports('foundational_security','ec2.21') }})
        union
        ({{ not_imdsv2_instances('foundational_security','ec2.8') }})
        union
        ({{ origin_access_identity_enabled('foundational_security','cloudfront.2') }})
        union
        ({{ origin_failover_enabled('foundational_security','cloudfront.4') }})
        union
        ({{ paravirtual_instances_should_not_be_used('foundational_security','ec2.24') }})
        union
        ({{ password_policy_strong('foundational_security','iam.7') }})
        union
        ({{ point_in_time_recovery('foundational_security','dynamodb.2') }})
        union
        ({{ policies_attached_to_groups_roles('foundational_security','iam.2') }})
        union
        ({{ policies_have_wildcard_actions('foundational_security','iam.21') }})
        union
        ({{ policies_with_admin_rights('foundational_security','iam.1') }})
        union
        ({{ private_repositories_have_image_scanning_configured('foundational_security','ecr.1') }})
        union
        ({{ private_repositories_have_tag_immutability_configured('foundational_security','ecr.2') }})
        union
        ({{ project_environment_has_logging_aws_configuration('foundational_security','codebuild.4') }})
        union
        ({{ project_environment_should_not_have_privileged_mode('foundational_security','codebuild.5') }})
        union
        ({{ publicly_readable_buckets('foundational_security','s3.2') }})
        union
        ({{ publicly_writable_buckets('foundational_security','s3.3') }})
        union
        ({{ rds_automatic_minor_version_upgrades_should_be_enabled('foundational_security','rds.13') }})
        union
        ({{ rds_cluster_default_admin_check('foundational_security','rds.24') }})
        union
        ({{ rds_cluster_encrypted_at_rest('foundational_security','rds.27') }})
        union
        ({{ rds_cluster_event_notifications_configured('foundational_security','rds.19') }})
        union
        ({{ rds_instance_default_admin_check('foundational_security','rds.25') }})
        union
        ({{ rds_instance_event_notifications_configured('foundational_security','rds.20') }})
        union
        ({{ rds_pg_event_notifications_configured('foundational_security','rds.21') }})
        union
        ({{ rds_sg_event_notifications_configured('foundational_security','rds.22') }})
        union
        ({{ rds_snapshots_public_prohibited('foundational_security','rds.1') }})
        union
        ({{ redis_clusters_have_autominorversionupgrade('foundational_security','elasticache.2') }})
        union
        ({{ redis_clusters_should_have_automatic_backups('foundational_security','elasticache.1') }})
        union
        ({{ redis_replication_groups_automatic_failover_enabled('foundational_security','elasticache.3') }})
        union
        ({{ redis_replication_groups_encrypted_at_rest('foundational_security','elasticache.4') }})
        union
        ({{ redis_replication_groups_encrypted_in_transit('foundational_security','elasticache.5') }})
        union
        ({{ redis_replication_groups_under_version_6_use_auth('foundational_security','elasticache.6') }})
        union
        ({{ redshift_cluster_kms_enabled('foundational_security','redshift.10') }})
        union
        ({{ redshift_default_admin_check('foundational_security','redshift.8') }})
        union
        ({{ redshift_default_db_name_check('foundational_security','redshift.9') }})
        union
        ({{ remove_unused_secrets_manager_secrets('foundational_security','secretmanager.3') }})
        union
        ({{ replication_not_public('foundational_security','dms.1') }})
        union
        ({{ repositories_have_at_least_one_lifecycle_policy('foundational_security','ecr.3') }})
        union
        ({{ restrict_cross_account_actions('foundational_security','s3.6') }})
        union
        ({{ root_user_no_access_keys('foundational_security','iam.4') }})
        union
        ({{ rsa_certificate_key_length_should_be_more_than_2048_bits('foundational_security','acm.2') }})
        union
        ({{ s3_bucket_default_lock_enabled('foundational_security','s3.15') }})
        union
        ({{ s3_bucket_level_public_access_prohibited('foundational_security','s3.8') }})
        union
        ({{ s3_bucket_logging_enabled('foundational_security','s3.9') }})
        union
        ({{ s3_event_notifications_enabled('foundational_security','s3.11') }})
        union
        ({{ s3_lifecycle_policy_check('foundational_security','s3.13') }})
        union
        ({{ s3_logs_encrypted('foundational_security','codebuild.3') }})
        union
        ({{ s3_server_side_encryption_enabled('foundational_security','s3.4') }})
        union
        ({{ s3_version_lifecycle_policy_check('foundational_security','s3.10') }})
        union
        ({{ sagemaker_notebook_instance_direct_internet_access_disabled('foundational_security','sagemaker.1') }})
        union
        ({{ sagemaker_notebook_instance_inside_vpc('foundational_security','sagemaker.2') }})
        union
        ({{ sagemaker_notebook_instance_root_access_check('foundational_security','sagemaker.3') }})
        union
        ({{ secrets_configured_with_automatic_rotation_should_rotate_successfully('foundational_security','secretmanager.2') }})
        union
        ({{ secrets_should_be_rotated_within_a_specified_number_of_days('foundational_security','secretmanager.4') }})
        union
        ({{ secrets_should_have_automatic_rotation_enabled('foundational_security','secretmanager.1') }})
        union
        ({{ secrets_should_not_be_in_environment_variables('foundational_security','ecs.8') }})
        union
        ({{ security_account_information_provided('foundational_security','account.1') }})
        union
         ({{ security_groups_not_associated('foundational_security','ec2.22') }})
        union 
        ({{ security_groups_with_access_to_unauthorized_ports('foundational_security','ec2.18') }})
        union
        ({{ security_groups_with_open_critical_ports('foundational_security','ec2.19') }})
        union
        ({{ sns_topics_should_be_encrypted_at_rest_using_aws_kms('foundational_security','sns.1') }})
        union
        ({{ sns_topics_should_have_message_delivery_notification_enabled('foundational_security','sns.2') }})
        union
        ({{ sqs_queues_should_be_encrypted_at_rest('foundational_security','sqs.1') }})
        union
        ({{ step_functions_state_machine_logging_enabled('foundational_security','stepfunctions.1') }})
        union
        ({{ stopped_more_than_30_days_ago_instances('foundational_security','ec2.4') }})
        union
        ({{ subnets_that_assign_public_ips('foundational_security','ec2.15') }})
        union
        ({{ task_definitions_secure_networking('foundational_security','ecs.1') }})
        union
        ({{ task_definitions_should_not_share_host_namespace('foundational_security','ecs.3') }})
        union
        ({{ transit_gateways_should_not_auto_accept_vpc_attachments('foundational_security','ec2.23') }})
        union
        ({{ unencrypted_ebs_volumes('foundational_security','ec2.3') }})
        union
        ({{ unencrypted_efs_filesystems('foundational_security','efs.1') }})
        union
        ({{ unused_acls('foundational_security','ec2.16') }})
        union
        ({{ viewer_policy_https('foundational_security','cloudfront.3') }})
        union
        ({{ vpcs_without_ec2_endpoint('foundational_security','ec2.10') }})
        union
        ({{ waf_global_rule_not_empty('foundational_security','waf.6') }})
        union
        ({{ waf_global_rulegroup_not_empty('foundational_security','waf.7') }})
        union
        ({{ waf_global_webacl_not_empty('foundational_security','waf.8') }})
        union
        ({{ waf_regional_rule_not_empty('foundational_security','waf.2') }})
        union
        ({{ waf_regional_rulegroup_not_empty('foundational_security','waf.3') }})
        union
        ({{ waf_regional_webacl_not_empty('foundational_security','waf.4') }})
        union
        ({{ waf_web_acl_logging_should_be_enabled('foundational_security','waf.1') }})
        union
        ({{ wafv2_webacl_not_empty('foundational_security','waf.10') }})
       
    )
select 
        ('{{ run_started_at }}')::timestamp as policy_execution_time,
        aggregated.*
from aggregated
# CloudQuery &times; dbt: AWS Compliance Package

## Overview

Welcome to AWS Compliance Package, a compliance solution that works on top of the CloudQuery framework. This package offers automated checks across various AWS services, following benchmarks such as CIS and AWS foundational security standards.
Using this solution you can get instant insights about your security posture and make sure you are following the recommended security guidelines defined by AWS, CIS and more.

We recommend to use this transformation with our [AWS Compliance Dashboard](https://hub.cloudquery.io/addons/visualization/cloudquery/aws-compliance/latest/docs)
![AWS Compliance Dashboard](./images/dashboard_example.png)

This is a premium package. To try this package for free see out limited [AWS Compliance Package (Free)](https://hub.cloudquery.io/addons/transformation/cloudquery/aws-compliance-free/latest/docs)

### Examples
How can I check that all my EC2 related resources are following the foundational security standards? (PostgreSQL)
```sql
SELECT *
FROM aws_compliance__foundational_security
WHERE check_id LIKE '%ec2.%'
```

How many checks failed in the CIS 2.0 benchmark? (PostgreSQL)
```sql
SELECT count(*) as failed_count
FROM aws_compliance__cis_v2_0_0
WHERE status = 'fail'
```

Which resource failed the most tests in the foundational security benchmark? (PostgreSQL)
```sql
SELECT resource_id, count(*) as failed_count
FROM aws_compliance__foundational_security
WHERE status = 'fail'
GROUP BY resource_id
ORDER BY count(*) DESC
```

### Requirements

- [dbt](https://docs.getdbt.com/docs/installation)
- [CloudQuery](https://www.cloudquery.io/docs/quickstart)
- [A CloudQuery Account](https://www.cloudquery.io/auth/register)
- [AWS Source Plugin](https://hub.cloudquery.io/plugins/source/cloudquery/aws/latest/docs)

One of the below databases

- [PostgreSQL](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql)
- [Snowflake](https://hub.cloudquery.io/plugins/destination/cloudquery/snowflake)
- [BigQuery](https://hub.cloudquery.io/plugins/destination/cloudquery/bigquery)

### What's in the pack

This package includes: Automated compliance checks following CIS, AWS Foundational Security, IMDS V2 and PCI DSS

## To run this package you need to complete the following steps

### Setting up the DBT profile (PostgreSQL)
First, [install `dbt`](https://docs.getdbt.com/docs/core/installation-overview):
```bash
pip install dbt-postgres
```

Create the profile directory:

```bash
mkdir -p ~/.dbt
```

Create a `profiles.yml` file in your profile directory (e.g. `~/.dbt/profiles.yml`):

```yaml
aws_compliance: # This should match the name in your dbt_project.yml
  target: dev
  outputs:
    dev:
      type: postgres
      host: 127.0.0.1
      user: postgres
      pass: pass
      port: 5432
      dbname: postgres
      schema: public # default schema where dbt will build the models
      threads: 1 # number of threads to use when running in parallel
```

Test the Connection:

After setting up your `profiles.yml`, you should test the connection to ensure everything is configured correctly:

```bash
dbt debug
```

This command will tell you if dbt can successfully connect to your PostgreSQL instance.

### Login to CloudQuery
Because this policy uses premium features and tables you must login to your cloudquery account using
`cloudquery login` in your terminal.

### Syncing AWS data
Based on the models you are interested in running, you need to sync the relevant tables.
this is an example sync for the relevant tables for all the models (views) in the policy and with the PostgreSQL destination. This package also supports Snowflake and Google BigQuery

 ```yml
kind: source
spec:
  name: aws # The source type, in this case, AWS.
  path: cloudquery/aws # The plugin path for handling AWS sources.
  registry: cloudquery # The registry from which the AWS plugin is sourced.
  version: "v25.5.3" # The version of the AWS plugin.
  tables: ["aws_neptune_cluster_snapshots","aws_apigatewayv2_api_stages","aws_elbv2_load_balancer_attributes","aws_ec2_images","aws_ec2_route_tables","aws_s3_bucket_public_access_blocks","aws_applicationautoscaling_policies","aws_autoscaling_groups","aws_s3_accounts","aws_wafv2_web_acls","aws_wafregional_rule_groups","aws_ssm_instance_compliance_items","aws_elbv1_load_balancers","aws_stepfunctions_state_machines","aws_ec2_network_acls","aws_iam_policies","aws_s3_bucket_encryption_rules","aws_cloudwatch_alarms","aws_efs_filesystems","aws_accessanalyzer_analyzers","aws_ec2_vpcs","aws_ecs_task_definitions","aws_autoscaling_launch_configurations","aws_iam_instance_profiles","aws_rds_instances","aws_ec2_instances","aws_iam_group_policies","aws_elbv2_load_balancers","aws_iam_groups","aws_dynamodb_table_continuous_backups","aws_lightsail_instances","aws_emr_clusters","aws_elasticbeanstalk_environments","aws_redshift_clusters","aws_iam_role_policies","aws_securityhub_hubs","aws_ecr_repository_lifecycle_policies","aws_s3_buckets","aws_dax_clusters","aws_apigateway_rest_apis","aws_iam_roles","aws_sns_subscriptions","aws_ec2_launch_template_versions","aws_eks_clusters","aws_s3_bucket_lifecycles","aws_ec2_subnets","aws_cloudwatchlogs_metric_filters","aws_ec2_vpn_connections","aws_iam_openid_connect_identity_providers","aws_s3_bucket_object_lock_configurations","aws_ecs_clusters","aws_sagemaker_notebook_instances","aws_codebuild_projects","aws_ec2_network_interfaces","aws_rds_events","aws_iam_accounts","aws_iam_saml_identity_providers","aws_iam_password_policies","aws_iam_user_attached_policies","aws_ec2_security_groups","aws_cloudtrail_trail_event_selectors","aws_iam_user_policies","aws_regions","aws_appsync_graphql_apis","aws_networkfirewall_rule_groups","aws_ec2_flow_logs","aws_iam_credential_reports","aws_networkfirewall_firewall_policies","aws_iam_group_attached_policies","aws_wafregional_web_acls","aws_elasticsearch_domains","aws_ec2_eips","aws_elasticbeanstalk_configuration_settings","aws_elasticache_clusters","aws_athena_work_groups","aws_redshift_cluster_parameter_groups","aws_iam_virtual_mfa_devices","aws_s3_bucket_grants","aws_waf_rules","aws_secretsmanager_secrets","aws_iam_role_attached_policies","aws_iam_server_certificates","aws_account_alternate_contacts","aws_iam_user_access_keys","aws_elbv1_load_balancer_policies","aws_cloudtrail_trails","aws_ssm_documents","aws_dynamodb_tables","aws_cloudfront_distributions","aws_rds_cluster_snapshots","aws_ssm_instances","aws_s3_bucket_replications","aws_ec2_ebs_volumes","aws_s3_bucket_notification_configurations","aws_dms_replication_instances","aws_elasticache_replication_groups","aws_waf_rule_groups","aws_neptune_clusters","aws_elbv2_listeners","aws_iam_users","aws_acm_certificates","aws_wafregional_rules","aws_ecs_cluster_services","aws_ec2_vpc_endpoints","aws_s3_bucket_policies","aws_ec2_ebs_snapshot_attributes","aws_guardduty_detectors","aws_efs_access_points","aws_config_configuration_recorders","aws_sns_topics","aws_rds_clusters","aws_s3_bucket_loggings","aws_sqs_queues","aws_ecr_repositories","aws_ec2_regional_configs","aws_lambda_runtimes","aws_lambda_functions","aws_apigateway_rest_api_stages","aws_redshift_cluster_parameters","aws_docdb_clusters","aws_ec2_transit_gateways","aws_s3_bucket_versionings","aws_rds_db_snapshots","aws_kinesis_streams","aws_iam_policy_versions","aws_apigatewayv2_apis","aws_kms_keys","aws_waf_web_acls","aws_apigatewayv2_api_routes","aws_cloudformation_stacks"]
  destinations: ["postgresql"] # The destination for the data, in this case, PostgreSQL.
  skip_dependent_tables: true
  spec:

---
kind: destination
spec:
  name: "postgresql" # The type of destination, in this case, PostgreSQL.
  path: "cloudquery/postgresql" # The plugin path for handling PostgreSQL as a destination.
  registry: "cloudquery" # The registry from which the PostgreSQL plugin is sourced.
  version: "v8.0.1" # The version of the PostgreSQL plugin.

  spec:
    connection_string: "${POSTGRESQL_CONNECTION_STRING}"  # set the environment variable in a format like 
    # postgresql://postgres:pass@localhost:5432/postgres?sslmode=disable
    # You can also specify the connection string in DSN format, which allows for special characters in the password:
    # connection_string: "user=postgres password=pass+0-[word host=localhost port=5432 dbname=postgres"

 ```

 See [Hub](https://hub.cloudquery.io) to browse individual plugins and to get their detailed documentation.

#### Running Your dbt Project

Navigate to your dbt project directory, where your `dbt_project.yml` resides. Make sure to have an existing profile in your `profiles.yml` that contains your PostgreSQL/Snowflake/BigQuery connection and authentication information.

If everything compiles without errors, you can then execute:

```bash
dbt run
```

This command will run all your `dbt` models and create tables/views in your destination database as defined in your models.

**Note:** If running locally, ensure you are using `dbt-core` and not `dbt-cloud-cli` as dbt-core does not require extra authentication.

To run specific models and the models in the dependency graph, the following `dbt run` commands can be used:

To select a specific model and the dependencies in the dependency graph:

```bash
dbt run --select +<model_name>
```

For a specific model and the dependencies in the dependency graph:

```bash
dbt run --models +<model_name>
```


### Models
The following models are available for PostgreSQL, Snowflake and Google BigQuery.
- **aws_compliance\_\_cis_v1_2_0**: AWS CIS V1.2.0.
- **aws_compliance\_\_cis_v2_0_0**: AWS CIS V2.0.0.
- **aws_compliance\_\_cis_v3_0_0**: AWS CIS V3.0.0.
- **aws_compliance\_\_foundational_security**: AWS Foundational Security.
- **aws_compliance\_\_pci_dss_v3_2_1**: AWS PCI DSS V3.2.1.
- **aws_compliance\_\_imds_v2**: IMDSv2 compliance checks.
- **aws_compliance\_\_public_egress**: Checks to find resources that can reach the public internet.
- **aws_compliance\_\_publicly_available**: Checks to find publicly accessible resources.

All of the models contain the following columns:
- **framework**: The benchmark the check belongs to.
- **check_id**: The check identifier (either a number or the service name and numberr).
- **title**: The name/title of the check.
- **account_id**: The AWS account id.
- **resource_id**: The resource id (ARN).
- **status**: The status of the check (fail / pass).

There are 


### Required tables
- **aws_compliance\_\_cis_v1_2_0**:
```yaml
"aws_iam_password_policies",
"aws_s3_buckets",
"aws_iam_users",
"aws_iam_user_attached_policies",
"aws_s3_bucket_loggings",
"aws_iam_user_access_keys",
"aws_cloudtrail_trail_event_selectors",
"aws_ec2_security_groups",
"aws_iam_user_policies",
"aws_cloudwatchlogs_metric_filters",
"aws_cloudtrail_trails",
"aws_cloudwatch_alarms",
"aws_ec2_flow_logs",
"aws_iam_virtual_mfa_devices",
"aws_ec2_vpcs",
"aws_iam_credential_reports",
"aws_kms_keys",
"aws_sns_subscriptions"
```
This model is dependent on the following models:
- aws_compliance__log_metric_filter_and_alarm
- aws_compliance__security_group_ingress_rules

- **aws_compliance\_\_cis_v2_0_0**:
```yaml
"aws_securityhub_hubs",
"aws_s3_buckets",
"aws_iam_users",
"aws_elasticache_clusters",
"aws_s3_bucket_policies",
"aws_iam_virtual_mfa_devices",
"aws_iam_roles",
"aws_s3_bucket_grants",
"aws_sns_subscriptions",
"aws_config_configuration_recorders",
"aws_s3_accounts",
"aws_s3_bucket_loggings",
"aws_cloudwatchlogs_metric_filters",
"aws_iam_openid_connect_identity_providers",
"aws_iam_role_attached_policies",
"aws_iam_server_certificates",
"aws_account_alternate_contacts",
"aws_ec2_network_acls",
"aws_iam_policies",
"aws_iam_user_access_keys",
"aws_cloudtrail_trails",
"aws_efs_filesystems",
"aws_cloudwatch_alarms",
"aws_accessanalyzer_analyzers",
"aws_ec2_vpcs",
"aws_s3_bucket_versionings",
"aws_iam_accounts",
"aws_iam_saml_identity_providers",
"aws_iam_instance_profiles",
"aws_iam_password_policies",
"aws_iam_user_attached_policies",
"aws_iam_policy_versions",
"aws_rds_instances",
"aws_ec2_ebs_volumes",
"aws_regions",
"aws_cloudtrail_trail_event_selectors",
"aws_ec2_instances",
"aws_iam_user_policies",
"aws_ec2_security_groups",
"aws_ec2_flow_logs",
"aws_iam_credential_reports",
"aws_kms_keys",
"aws_iam_group_attached_policies"
```
This model is dependent on the following models:
- aws_compliance__log_metric_filter_and_alarm
- aws_compliance__networks_acls_ingress_rules
- aws_compliance__security_group_ingress_rules

- **aws_compliance\_\_cis_v3_0_0**:
```yaml
"aws_securityhub_hubs",
"aws_s3_buckets",
"aws_iam_users",
"aws_elasticache_clusters",
"aws_s3_bucket_policies",
"aws_iam_virtual_mfa_devices",
"aws_iam_roles",
"aws_sns_subscriptions",
"aws_config_configuration_recorders",
"aws_s3_accounts",
"aws_s3_bucket_loggings",
"aws_cloudwatchlogs_metric_filters",
"aws_iam_openid_connect_identity_providers",
"aws_iam_role_attached_policies",
"aws_iam_server_certificates",
"aws_account_alternate_contacts",
"aws_ec2_network_acls",
"aws_iam_policies",
"aws_iam_user_access_keys",
"aws_cloudtrail_trails",
"aws_efs_filesystems",
"aws_cloudwatch_alarms",
"aws_accessanalyzer_analyzers",
"aws_ec2_vpcs",
"aws_s3_bucket_versionings",
"aws_iam_accounts",
"aws_iam_saml_identity_providers",
"aws_iam_instance_profiles",
"aws_iam_password_policies",
"aws_iam_user_attached_policies",
"aws_iam_policy_versions",
"aws_rds_instances",
"aws_ec2_ebs_volumes",
"aws_regions",
"aws_cloudtrail_trail_event_selectors",
"aws_ec2_instances",
"aws_iam_user_policies",
"aws_ec2_security_groups",
"aws_ec2_flow_logs",
"aws_iam_credential_reports",
"aws_kms_keys",
"aws_iam_group_attached_policies"
```
This model is dependent on the following models:
- aws_compliance__log_metric_filter_and_alarm
- aws_compliance__networks_acls_ingress_rules
- aws_compliance__security_group_ingress_rules


- **aws_compliance\_\_foundational_security**:
```yaml
"aws_neptune_cluster_snapshots",
"aws_apigatewayv2_api_stages",
"aws_elbv2_load_balancer_attributes",
"aws_s3_bucket_public_access_blocks",
"aws_applicationautoscaling_policies",
"aws_autoscaling_groups",
"aws_s3_accounts",
"aws_wafv2_web_acls",
"aws_wafregional_rule_groups",
"aws_ssm_instance_compliance_items",
"aws_elbv1_load_balancers",
"aws_stepfunctions_state_machines",
"aws_ec2_network_acls",
"aws_iam_policies",
"aws_s3_bucket_encryption_rules",
"aws_efs_filesystems",
"aws_ec2_vpcs",
"aws_ecs_task_definitions",
"aws_autoscaling_launch_configurations",
"aws_rds_instances",
"aws_ec2_instances",
"aws_iam_group_policies",
"aws_elbv2_load_balancers",
"aws_iam_groups",
"aws_dynamodb_table_continuous_backups",
"aws_emr_clusters",
"aws_elasticbeanstalk_environments",
"aws_redshift_clusters",
"aws_iam_role_policies",
"aws_ecr_repository_lifecycle_policies",
"aws_s3_buckets",
"aws_dax_clusters",
"aws_apigateway_rest_apis",
"aws_iam_roles",
"aws_ec2_launch_template_versions",
"aws_eks_clusters",
"aws_s3_bucket_lifecycles",
"aws_ec2_subnets",
"aws_ec2_vpn_connections",
"aws_s3_bucket_object_lock_configurations",
"aws_ecs_clusters",
"aws_sagemaker_notebook_instances",
"aws_codebuild_projects",
"aws_ec2_network_interfaces",
"aws_rds_events",
"aws_iam_accounts",
"aws_iam_password_policies",
"aws_iam_user_attached_policies",
"aws_ec2_security_groups",
"aws_regions",
"aws_iam_user_policies",
"aws_cloudtrail_trail_event_selectors",
"aws_appsync_graphql_apis",
"aws_networkfirewall_rule_groups",
"aws_ec2_flow_logs",
"aws_iam_credential_reports",
"aws_networkfirewall_firewall_policies",
"aws_wafregional_web_acls",
"aws_elasticsearch_domains",
"aws_elasticbeanstalk_configuration_settings",
"aws_elasticache_clusters",
"aws_athena_work_groups",
"aws_redshift_cluster_parameter_groups",
"aws_iam_virtual_mfa_devices",
"aws_s3_bucket_grants",
"aws_waf_rules",
"aws_secretsmanager_secrets",
"aws_account_alternate_contacts",
"aws_iam_user_access_keys",
"aws_elbv1_load_balancer_policies",
"aws_cloudtrail_trails",
"aws_ssm_documents",
"aws_dynamodb_tables",
"aws_cloudfront_distributions",
"aws_rds_cluster_snapshots",
"aws_ssm_instances",
"aws_ec2_ebs_volumes",
"aws_s3_bucket_notification_configurations",
"aws_dms_replication_instances",
"aws_elasticache_replication_groups",
"aws_waf_rule_groups",
"aws_neptune_clusters",
"aws_elbv2_listeners",
"aws_iam_users",
"aws_acm_certificates",
"aws_wafregional_rules",
"aws_ecs_cluster_services",
"aws_ec2_vpc_endpoints",
"aws_ec2_ebs_snapshot_attributes",
"aws_guardduty_detectors",
"aws_efs_access_points",
"aws_s3_bucket_policies",
"aws_config_configuration_recorders",
"aws_sns_topics",
"aws_rds_clusters",
"aws_s3_bucket_loggings",
"aws_sqs_queues",
"aws_ecr_repositories",
"aws_ec2_regional_configs",
"aws_lambda_runtimes",
"aws_lambda_functions",
"aws_apigateway_rest_api_stages",
"aws_redshift_cluster_parameters",
"aws_docdb_clusters",
"aws_ec2_transit_gateways",
"aws_s3_bucket_versionings",
"aws_rds_db_snapshots",
"aws_kinesis_streams",
"aws_iam_policy_versions",
"aws_apigatewayv2_apis",
"aws_kms_keys",
"aws_waf_web_acls",
"aws_apigatewayv2_api_routes",
"aws_cloudformation_stacks"
```
This model is dependent on the following models:
- aws_compliance__api_gateway_method_settings
- aws_compliance__security_group_ingress_rules

- **aws_compliance\_\_pci_dss_v3_2_1**:
```yaml
"aws_ec2_eips",
"aws_elbv2_listeners",
"aws_iam_users",
"aws_s3_buckets",
"aws_guardduty_detectors",
"aws_s3_bucket_policies",
"aws_ec2_ebs_snapshot_attributes",
"aws_iam_virtual_mfa_devices",
"aws_s3_bucket_public_access_blocks",
"aws_s3_bucket_grants",
"aws_sns_subscriptions",
"aws_autoscaling_groups",
"aws_config_configuration_recorders",
"aws_s3_accounts",
"aws_wafv2_web_acls",
"aws_ssm_instance_compliance_items",
"aws_secretsmanager_secrets",
"aws_cloudwatchlogs_metric_filters",
"aws_lambda_functions",
"aws_sagemaker_notebook_instances",
"aws_codebuild_projects",
"aws_iam_user_access_keys",
"aws_iam_policies",
"aws_s3_bucket_encryption_rules",
"aws_cloudtrail_trails",
"aws_cloudwatch_alarms",
"aws_ec2_vpcs",
"aws_iam_accounts",
"aws_rds_cluster_snapshots",
"aws_ssm_instances",
"aws_s3_bucket_replications",
"aws_iam_password_policies",
"aws_iam_user_attached_policies",
"aws_iam_policy_versions",
"aws_rds_instances",
"aws_regions",
"aws_cloudtrail_trail_event_selectors",
"aws_ec2_instances",
"aws_iam_user_policies",
"aws_ec2_security_groups",
"aws_dms_replication_instances",
"aws_ec2_flow_logs",
"aws_iam_credential_reports",
"aws_kms_keys",
"aws_waf_web_acls",
"aws_redshift_clusters",
"aws_elasticsearch_domains"
```
This model is dependent on the following models:
- aws_compliance__log_metric_filter_and_alarm
- aws_compliance__security_group_ingress_rules

- **aws_compliance\_\_imds_v2**:
```yaml
"aws_ec2_images",
"aws_ec2_instances",
"aws_lightsail_instances"
```
- **aws_compliance\_\_public_egress**:
```yaml
"aws_ec2_instances",
"aws_ec2_route_tables",
"aws_lambda_functions",
"aws_ec2_security_groups"
```
This model is dependent on the following models:
- aws_compliance__security_group_egress_rules

- **aws_compliance\_\_publicly_available**:
```yaml
"aws_cloudfront_distributions",
"aws_ec2_instances",
"aws_elbv1_load_balancers",
"aws_apigateway_rest_apis",
"aws_elbv2_load_balancers",
"aws_redshift_clusters",
"aws_apigatewayv2_apis",
"aws_rds_instances"
```

<!-- AUTO-GENERATED-INCLUDED-CHECKS-START -->
#### Included Checks

##### `cis_v1.2.0`

- ✅ `1.1`: `avoid_root_usage`
- ✅ `1.2`: `mfa_enabled_for_console_access`
- ✅ `1.3`: `unused_creds_disabled`
- ✅ `1.4`: `old_access_keys`
- ✅ `1.5`: `password_policy_min_uppercase`
- ✅ `1.6`: `password_policy_min_lowercase`
- ✅ `1.7`: `password_policy_min_one_symbol`
- ✅ `1.8`: `password_policy_min_number`
- ✅ `1.9`: `password_policy_min_length`
- ✅ `1.10`: `password_policy_prevent_reuse`
- ✅ `1.11`: `password_policy_expire_old_passwords`
- ✅ `1.12`: `root_user_no_access_keys`
- ✅ `1.13`: `mfa_enabled_for_root`
- ✅ `1.14`: `hardware_mfa_enabled_for_root`
- ✅ `1.16`: `policies_attached_to_groups_roles`
- ✅ `2.1`: `cloudtrail_enabled_all_regions`
- ✅ `2.2`: `log_file_validation_enabled`
- ✅ `2.4`: `integrated_with_cloudwatch_logs`
- ✅ `2.6`: `bucket_access_logging`
- ✅ `2.7`: `logs_encrypted`
- ✅ `2.8`: `rotation_enabled_for_customer_key`
- ✅ `2.9`: `flow_logs_enabled_in_all_vpcs`
- ✅ `3.1`: `alarm_unauthorized_api`
- ✅ `3.3`: `alarm_root_account`
- ✅ `3.4`: `alarm_iam_policy_change`
- ✅ `3.5`: `alarm_cloudtrail_config_changes`
- ✅ `3.6`: `alarm_console_auth_failure`
- ✅ `3.7`: `alarm_delete_customer_cmk`
- ✅ `3.8`: `alarm_s3_bucket_policy_change`
- ✅ `3.9`: `alarm_aws_config_changes`
- ✅ `3.10`: `alarm_security_group_changes`
- ✅ `3.11`: `alarm_nacl_changes`
- ✅ `3.12`: `alarm_network_gateways`
- ✅ `3.13`: `alarm_route_table_changes`
- ✅ `3.14`: `alarm_vpc_changes`
- ✅ `4.1`: `no_broad_public_ingress_on_port_22`
- ✅ `4.2`: `no_broad_public_ingress_on_port_3389`
- ✅ `4.3`: `default_sg_no_access`

##### `cis_v2.0.0`

- ✅ `1.2`: `security_account_information_provided`
- ✅ `1.4`: `iam_root_user_no_access_keys`
- ✅ `1.5`: `mfa_enabled_for_root`
- ✅ `1.6`: `hardware_mfa_enabled_for_root`
- ✅ `1.7`: `iam_root_last_used`
- ✅ `1.8`: `password_policy_min_length`
- ✅ `1.9`: `password_policy_prevent_reuse`
- ✅ `1.10`: `mfa_enabled_for_console_access`
- ✅ `1.11`: `iam_user_access_keys_and_password_at_setup`
- ✅ `1.12`: `unused_creds_disabled_45_days`
- ✅ `1.13`: `users_with_two_active_access_keys`
- ✅ `1.14`: `old_access_keys`
- ✅ `1.15`: `policies_attached_to_groups_roles`
- ✅ `1.16`: `no_star`
- ✅ `1.17`: `iam_support_role`
- ✅ `1.18`: `use_iam_roles_for_instances`
- ✅ `1.19`: `iam_server_certificate_not_expired`
- ✅ `1.20`: `regions_with_no_accessanalyzers`
- ✅ `1.21`: `iam_users_are_managed_centrally`
- ✅ `1.22`: `iam_user_group_role_cloudshell_fullaccess_restricted`
- ✅ `2.1.1`: `deny_http_requests`
- ✅ `2.1.2`: `mfa_delete`
- ✅ `2.1.4`: `account_level_public_access_blocks`
- ✅ `2.2.1`: `unencrypted_ebs_volumes`
- ✅ `2.3.1`: `instances_should_have_ecnryption_at_rest_enabled`
- ✅ `2.3.2`: `redis_clusters_have_autominorversionupgrade`
- ✅ `2.3.3`: `rds_db_instances_should_prohibit_public_access`
- ✅ `2.4.1`: `unencrypted_efs_filesystems`
- ✅ `3.1`: `cloudtrail_enabled_all_regions`
- ✅ `3.2`: `log_file_validation_enabled`
- ✅ `3.3`: `cloudtrail_bucket_not_public`
- ✅ `3.4`: `integrated_with_cloudwatch_logs`
- ✅ `3.5`: `config_enabled_all_regions`
- ✅ `3.6`: `bucket_access_logging`
- ✅ `3.7`: `logs_encrypted`
- ✅ `3.8`: `rotation_enabled_for_customer_key`
- ✅ `3.9`: `flow_logs_enabled_in_all_vpcs`
- ✅ `3.10`: `cloudtrail_s3_object_write_events_audit_enabled`
- ✅ `3.11`: `cloudtrail_s3_object_read_events_audit_enabled`
- ✅ `4.1`: `alarm_unauthorized_api`
- ✅ `4.2`: `alarm_console_no_mfa`
- ✅ `4.3`: `alarm_root_account`
- ✅ `4.4`: `alarm_iam_policy_change`
- ✅ `4.5`: `alarm_cloudtrail_config_changes`
- ✅ `4.6`: `alarm_console_auth_failure`
- ✅ `4.7`: `alarm_delete_customer_cmk`
- ✅ `4.8`: `alarm_s3_bucket_policy_change`
- ✅ `4.9`: `alarm_aws_config_changes`
- ✅ `4.10`: `alarm_security_group_changes`
- ✅ `4.11`: `alarm_nacl_changes`
- ✅ `4.12`: `alarm_network_gateways`
- ✅ `4.13`: `alarm_route_table_changes`
- ✅ `4.14`: `alarm_vpc_changes`
- ✅ `4.15`: `alarm_organization_changes`
- ✅ `4.16`: `securityhub_enabled`
- ✅ `5.1`: `vpc_network_acl_remote_administration`
- ✅ `5.2`: `vpc_security_group_remote_administration_ipv4`
- ✅ `5.3`: `no_broad_public_ipv6_ingress_on_port_22_3389`
- ✅ `5.4`: `default_sg_no_access`
- ✅ `5.6`: `ec2_not_imdsv2_instances`

##### `cis_v3.0.0`

- ✅ `1.2`: `security_account_information_provided`
- ✅ `1.4`: `iam_root_user_no_access_keys`
- ✅ `1.5`: `mfa_enabled_for_root`
- ✅ `1.6`: `hardware_mfa_enabled_for_root`
- ✅ `1.7`: `iam_root_last_used`
- ✅ `1.8`: `password_policy_min_length`
- ✅ `1.9`: `password_policy_prevent_reuse`
- ✅ `1.10`: `mfa_enabled_for_console_access`
- ✅ `1.11`: `iam_user_access_keys_and_password_at_setup`
- ✅ `1.12`: `unused_creds_disabled_45_days`
- ✅ `1.13`: `users_with_two_active_access_keys`
- ✅ `1.14`: `old_access_keys`
- ✅ `1.15`: `policies_attached_to_groups_roles`
- ✅ `1.16`: `no_star`
- ✅ `1.17`: `iam_support_role`
- ✅ `1.18`: `use_iam_roles_for_instances`
- ✅ `1.19`: `iam_server_certificate_not_expired`
- ✅ `1.20`: `regions_with_no_accessanalyzers`
- ✅ `1.21`: `iam_users_are_managed_centrally`
- ✅ `1.22`: `iam_user_group_role_cloudshell_fullaccess_restricted`
- ✅ `2.1.1`: `deny_http_requests`
- ✅ `2.1.2`: `mfa_delete`
- ✅ `2.1.4`: `account_level_public_access_blocks`
- ✅ `2.2.1`: `unencrypted_ebs_volumes`
- ✅ `2.3.1`: `instances_should_have_ecnryption_at_rest_enabled`
- ✅ `2.3.2`: `redis_clusters_have_autominorversionupgrade`
- ✅ `2.3.3`: `rds_db_instances_should_prohibit_public_access`
- ✅ `2.4.1`: `unencrypted_efs_filesystems`
- ✅ `3.1`: `cloudtrail_enabled_all_regions`
- ✅ `3.2`: `log_file_validation_enabled`
- ✅ `3.3`: `config_enabled_all_regions`
- ✅ `3.4`: `bucket_access_logging`
- ✅ `3.5`: `logs_encrypted`
- ✅ `3.6`: `rotation_enabled_for_customer_key`
- ✅ `3.7`: `flow_logs_enabled_in_all_vpcs`
- ✅ `3.8`: `cloudtrail_s3_object_write_events_audit_enabled`
- ✅ `3.9`: `cloudtrail_s3_object_read_events_audit_enabled`
- ✅ `4.1`: `alarm_unauthorized_api`
- ✅ `4.2`: `alarm_console_no_mfa`
- ✅ `4.3`: `alarm_root_account`
- ✅ `4.4`: `alarm_iam_policy_change`
- ✅ `4.5`: `alarm_cloudtrail_config_changes`
- ✅ `4.6`: `alarm_console_auth_failure`
- ✅ `4.7`: `alarm_delete_customer_cmk`
- ✅ `4.8`: `alarm_s3_bucket_policy_change`
- ✅ `4.9`: `alarm_aws_config_changes`
- ✅ `4.10`: `alarm_security_group_changes`
- ✅ `4.11`: `alarm_nacl_changes`
- ✅ `4.12`: `alarm_network_gateways`
- ✅ `4.13`: `alarm_route_table_changes`
- ✅ `4.14`: `alarm_vpc_changes`
- ✅ `4.15`: `alarm_organization_changes`
- ✅ `4.16`: `securityhub_enabled`
- ✅ `5.1`: `vpc_network_acl_remote_administration`
- ✅ `5.2`: `vpc_security_group_remote_administration_ipv4`
- ✅ `5.3`: `no_broad_public_ipv6_ingress_on_port_22_3389`
- ✅ `5.4`: `default_sg_no_access`
- ✅ `5.6`: `ec2_not_imdsv2_instances`

##### `foundational_security`

- ✅ `account.1`: `security_account_information_provided`
- ✅ `acm.1`: `certificates_should_be_renewed`
- ✅ `acm.2`: `rsa_certificate_key_length_should_be_more_than_2048_bits`
- ✅ `apigateway.1`: `api_gw_execution_logging_enabled`
- ✅ `apigateway.2`: `api_gw_stage_should_use_ssl`
- ✅ `apigateway.3`: `api_gw_stage_should_have_xray_tracing_enabled`
- ✅ `apigateway.4`: `api_gw_associated_wth_waf`
- ✅ `apigateway.5`: `api_gw_cache_data_encrypted`
- ✅ `apigateway.8`: `api_gw_routes_should_specify_authorization_type`
- ✅ `apigateway.9`: `api_gw_access_logging_should_be_configured`
- ✅ `appsync.2`: `appsync_should_have_logging_turned_on`
- ✅ `athena.1`: `athena_workgroup_encrypted_at_rest`
- ✅ `autoscaling.1`: `autoscaling_group_elb_healthcheck_required`
- ✅ `autoscaling.2`: `autoscaling_multiple_az`
- ✅ `autoscaling.3`: `autoscaling_launchconfig_requires_imdsv2`
- ✅ `autoscaling.4`: `autoscaling_launch_config_hop_limit`
- ✅ `autoscaling.5`: `autoscaling_launch_config_public_ip_disabled`
- ✅ `autoscaling.6`: `autoscaling_multiple_instance_types`
- ✅ `autoscaling.9`: `autoscaling_launch_template`
- ✅ `awsconfig.1`: `config_enabled_all_regions`
- ✅ `cloudformation.1`: `cloudformation_stack_notification_check`
- ✅ `cloudfront.1`: `default_root_object_configured`
- ✅ `cloudfront.2`: `origin_access_identity_enabled`
- ✅ `cloudfront.3`: `viewer_policy_https`
- ✅ `cloudfront.4`: `origin_failover_enabled`
- ✅ `cloudfront.5`: `access_logs_enabled`
- ✅ `cloudfront.6`: `associated_with_waf`
- ✅ `cloudfront.7`: `distribution_should_use_ssl_tls_certificates`
- ✅ `cloudfront.8`: `distribution_should_use_sni`
- ✅ `cloudfront.9`: `distribution_should_encrypt_traffic_to_custom_origins`
- ✅ `cloudfront.10`: `distribution_should_not_use_depricated_ssl_protocols`
- ✅ `cloudfront.12`: `distribution_should_not_point_to_non_existent_s3_origins`
- ✅ `cloudfront.13`: `distribution_should_use_origin_access_control`
- ✅ `cloudtrail.1`: `cloudtrail_enabled_all_regions`
- ✅ `cloudtrail.2`: `logs_encrypted`
- ✅ `cloudtrail.3`: `logs_file_validation_enabled`
- ✅ `cloudtrail.4`: `logs_file_validation_enabled`
- ✅ `cloudtrail.5`: `integrated_with_cloudwatch_logs`
- ✅ `codebuild.1`: `check_oauth_usage_for_sources`
- ✅ `codebuild.2`: `check_environment_variables`
- ✅ `codebuild.3`: `s3_logs_encrypted`
- ✅ `codebuild.4`: `project_environment_has_logging_aws_configuration`
- ✅ `codebuild.5`: `project_environment_should_not_have_privileged_mode`
- ✅ `dms.1`: `replication_not_public`
- ✅ `documentdb.1`: `clusters_should_be_encrypted_at_rest`
- ✅ `documentdb.2`: `clusters_should_have_7_days_backup_retention`
- ✅ `dynamodb.1`: `autoscale_or_ondemand`
- ✅ `dynamodb.2`: `point_in_time_recovery`
- ✅ `dynamodb.3`: `dax_encrypted_at_rest`
- ✅ `ec2.1`: `ebs_snapshot_permissions_check`
- ✅ `ec2.2`: `default_sg_no_access`
- ✅ `ec2.3`: `unencrypted_ebs_volumes`
- ✅ `ec2.4`: `stopped_more_than_30_days_ago_instances`
- ✅ `ec2.6`: `flow_logs_enabled_in_all_vpcs`
- ✅ `ec2.7`: `ebs_encryption_by_default_disabled`
- ✅ `ec2.8`: `not_imdsv2_instances`
- ✅ `ec2.9`: `instances_with_public_ip`
- ✅ `ec2.10`: `vpcs_without_ec2_endpoint`
- ✅ `ec2.15`: `subnets_that_assign_public_ips`
- ✅ `ec2.16`: `unused_acls`
- ✅ `ec2.17`: `instances_with_more_than_2_network_interfaces`
- ✅ `ec2.18`: `security_groups_with_access_to_unauthorized_ports`
- ✅ `ec2.19`: `security_groups_with_open_critical_ports`
- ✅ `ec2.20`: `both_vpn_channels_should_be_up`
- ✅ `ec2.21`: `network_acls_should_not_allow_ingress_for_ssh_rdp_ports`
- ✅ `ec2.22`: `security_groups_not_associated`
- ✅ `ec2.23`: `transit_gateways_should_not_auto_accept_vpc_attachments`
- ✅ `ec2.24`: `paravirtual_instances_should_not_be_used`
- ✅ `ec2.25`: `launch_templates_should_not_assign_public_ip`
- ✅ `ecr.1`: `private_repositories_have_image_scanning_configured`
- ✅ `ecr.2`: `private_repositories_have_tag_immutability_configured`
- ✅ `ecr.3`: `repositories_have_at_least_one_lifecycle_policy`
- ✅ `ecs.1`: `task_definitions_secure_networking`
- ✅ `ecs.2`: `ecs_services_with_public_ips`
- ✅ `ecs.3`: `task_definitions_should_not_share_host_namespace`
- ✅ `ecs.4`: `containers_should_run_as_non_privileged`
- ✅ `ecs.5`: `containers_limited_read_only_root_filesystems`
- ✅ `ecs.8`: `secrets_should_not_be_in_environment_variables`
- ✅ `ecs.10`: `fargate_should_run_on_latest_version`
- ✅ `ecs.12`: `clusters_should_use_container_insights`
- ✅ `efs.1`: `unencrypted_efs_filesystems`
- ✅ `efs.2`: `efs_filesystems_with_disabled_backups`
- ✅ `efs.3`: `access_point_path_should_not_be_root`
- ✅ `efs.4`: `access_point_enforce_user_identity`
- ✅ `eks.1`: `cluster_endpoints_not_publicly_accessible`
- ✅ `eks.2`: `clusters_should_run_on_supported_kuberneters_version`
- ✅ `elastic_beanstalk.1`: `advanced_health_reporting_enabled`
- ✅ `elastic_beanstalk.2`: `elastic_beanstalk_managed_updates_enabled`
- ✅ `elastic_beanstalk.3`: `elastic_beanstalk_stream_logs_to_cloudwatch`
- ✅ `elastic_search.1`: `elasticsearch_domains_should_have_encryption_at_rest_enabled`
- ✅ `elastic_search.2`: `elasticsearch_domains_should_be_in_vpc`
- ✅ `elastic_search.3`: `elasticsearch_domains_should_encrypt_data_sent_between_nodes`
- ✅ `elastic_search.4`: `elasticsearch_domain_error_logging_to_cloudwatch_logs_should_be_enabled`
- ✅ `elastic_search.5`: `elasticsearch_domains_should_have_audit_logging_enabled`
- ✅ `elastic_search.6`: `elasticsearch_domains_should_have_at_least_three_data_nodes`
- ✅ `elastic_search.7`: `elasticsearch_domains_should_be_configured_with_at_least_three_dedicated_master_nodes`
- ✅ `elastic_search.8`: `connections_to_elasticsearch_domains_should_be_encrypted_using_tls_1_2`
- ✅ `elasticache.1`: `redis_clusters_should_have_automatic_backups`
- ✅ `elasticache.2`: `redis_clusters_have_autominorversionupgrade`
- ✅ `elasticache.3`: `redis_replication_groups_automatic_failover_enabled`
- ✅ `elasticache.4`: `redis_replication_groups_encrypted_at_rest`
- ✅ `elasticache.5`: `redis_replication_groups_encrypted_in_transit`
- ✅ `elasticache.6`: `redis_replication_groups_under_version_6_use_auth`
- ✅ `elasticache.7`: `clusters_should_not_use_default_subnet_group`
- ✅ `elb.2`: `elbv1_cert_provided_by_acm`
- ✅ `elb.3`: `elbv1_https_or_tls`
- ✅ `elb.4`: `alb_drop_http_headers`
- ✅ `elb.5`: `alb_logging_enabled`
- ✅ `elb.6`: `alb_deletion_protection_enabled`
- ✅ `elb.7`: `elbv1_conn_draining_enabled`
- ✅ `elb.8`: `elbv1_https_predefined_policy`
- ✅ `elb.9`: `elbv1_have_cross_zone_load_balancing`
- ✅ `elb.10`: `elbv1_have_multiple_availability_zones`
- ✅ `elb.14`: `elbv1_desync_migration_mode_defensive_or_strictest`
- ✅ `elbv2.1`: `elbv2_redirect_http_to_https`
- ✅ `elbv2.12`: `elbv2_desync_migration_mode_defensive_or_strictest`
- ✅ `elbv2.13`: `elbv2_have_multiple_availability_zones`
- ✅ `emr.1`: `emr_cluster_master_nodes_should_not_have_public_ip_addresses`
- ✅ `guarddury.1`: `detector_enabled`
- ✅ `iam.1`: `policies_with_admin_rights`
- ✅ `iam.2`: `policies_attached_to_groups_roles`
- ✅ `iam.3`: `iam_access_keys_rotated_more_than_90_days`
- ✅ `iam.4`: `root_user_no_access_keys`
- ✅ `iam.5`: `mfa_enabled_for_console_access`
- ✅ `iam.6`: `hardware_mfa_enabled_for_root`
- ✅ `iam.7`: `password_policy_strong`
- ✅ `iam.8`: `iam_access_keys_rotated_more_than_90_days`
- ✅ `iam.21`: `policies_have_wildcard_actions`
- ✅ `kinesis`: `kinesis_stream_encrypted`
- ✅ `kms.1`: `iam_customer_policy_no_kms_decrypt`
- ✅ `kms.2`: `iam_inline_policy_no_kms_decrypt`
- ✅ `kms.3`: `keys_not_unintentionally_deleted`
- ✅ `kms.4`: `key_rotation_enabled`
- ✅ `lambda.1`: `lambda_function_public_access_prohibited`
- ✅ `lambda.2`: `lambda_functions_should_use_supported_runtimes`
- ✅ `lambda.3`: `lambda_inside_vpc`
- ✅ `lambda.5`: `lambda_vpc_multi_az_check`
- ✅ `neptune.1`: `neptune_cluster_encrypted`
- ✅ `neptune.2`: `neptune_cluster_cloudwatch_log_export_enabled`
- ✅ `neptune.3`: `neptune_cluster_snapshot_public_prohibited`
- ✅ `neptune.4`: `neptune_cluster_deletion_protection_enabled`
- ✅ `neptune.5`: `neptune_cluster_backup_retention_check`
- ✅ `neptune.6`: `neptune_cluster_snapshot_encrypted`
- ✅ `neptune.7`: `neptune_cluster_iam_database_authentication`
- ✅ `neptune.8`: `neptune_cluster_copy_tags_to_snapshot_enabled`
- ✅ `networkfirewall.3`: `netfw_policy_rule_group_associated`
- ✅ `networkfirewall.4`: `netfw_policy_default_action_full_packets`
- ✅ `networkfirewall.5`: `netfw_policy_default_action_fragment_packets`
- ✅ `networkfirewall.6`: `netfw_stateless_rule_group_not_empty`
- ✅ `rds.1`: `rds_snapshots_public_prohibited`
- ✅ `rds.2`: `instances_should_prohibit_public_access`
- ✅ `rds.3`: `instances_should_have_ecnryption_at_rest_enabled`
- ✅ `rds.4`: `cluster_snapshots_and_database_snapshots_should_be_encrypted_at_rest`
- ✅ `rds.5`: `instances_should_be_configured_with_multiple_azs`
- ✅ `rds.6`: `enhanced_monitoring_should_be_configured_for_instances_and_clusters`
- ✅ `rds.7`: `clusters_should_have_deletion_protection_enabled`
- ✅ `rds.8`: `instances_should_have_deletion_protection_enabled`
- ✅ `rds.9`: `database_logging_should_be_enabled`
- ✅ `rds.10`: `iam_authentication_should_be_configured_for_rds_instances`
- ✅ `rds.11`: `db_instance_backup_enabled`
- ✅ `rds.12`: `iam_authentication_should_be_configured_for_rds_clusters`
- ✅ `rds.13`: `rds_automatic_minor_version_upgrades_should_be_enabled`
- ✅ `rds.14`: `amazon_aurora_clusters_should_have_backtracking_enabled`
- ✅ `rds.15`: `clusters_should_be_configured_for_multiple_availability_zones`
- ✅ `rds.16`: `clusters_should_be_configured_to_copy_tags_to_snapshots`
- ✅ `rds.17`: `instances_should_be_configured_to_copy_tags_to_snapshots`
- ✅ `rds.18`: `instances_should_be_deployed_in_a_vpc`
- ✅ `rds.19`: `rds_cluster_event_notifications_configured`
- ✅ `rds.20`: `rds_instance_event_notifications_configured`
- ✅ `rds.21`: `rds_pg_event_notifications_configured`
- ✅ `rds.22`: `rds_sg_event_notifications_configured`
- ✅ `rds.23`: `databases_and_clusters_should_not_use_database_engine_default_port`
- ✅ `rds.24`: `rds_cluster_default_admin_check`
- ✅ `rds.25`: `rds_instance_default_admin_check`
- ✅ `rds.27`: `rds_cluster_encrypted_at_rest`
- ✅ `redshift.1`: `cluster_publicly_accessible`
- ✅ `redshift.2`: `clusters_should_be_encrypted_in_transit`
- ✅ `redshift.3`: `clusters_should_have_automatic_snapshots_enabled`
- ✅ `redshift.4`: `clusters_should_have_audit_logging_enabled`
- ✅ `redshift.6`: `clusters_should_have_automatic_upgrades_to_major_versions_enabled`
- ✅ `redshift.7`: `clusters_should_use_enhanced_vpc_routing`
- ✅ `redshift.8`: `redshift_default_admin_check`
- ✅ `redshift.9`: `redshift_default_db_name_check`
- ✅ `redshift.10`: `redshift_cluster_kms_enabled`
- ✅ `s3.1`: `account_level_public_access_blocks`
- ✅ `s3.2`: `publicly_readable_buckets`
- ✅ `s3.3`: `publicly_writable_buckets`
- ✅ `s3.4`: `s3_server_side_encryption_enabled`
- ✅ `s3.5`: `deny_http_requests`
- ✅ `s3.6`: `restrict_cross_account_actions`
- ✅ `s3.8`: `s3_bucket_level_public_access_prohibited`
- ✅ `s3.9`: `s3_bucket_logging_enabled`
- ✅ `s3.10`: `s3_version_lifecycle_policy_check`
- ✅ `s3.11`: `s3_event_notifications_enabled`
- ✅ `s3.13`: `s3_lifecycle_policy_check`
- ✅ `s3.15`: `s3_bucket_default_lock_enabled`
- ✅ `sagemaker.1`: `sagemaker_notebook_instance_direct_internet_access_disabled`
- ✅ `sagemaker.2`: `sagemaker_notebook_instance_inside_vpc`
- ✅ `sagemaker.3`: `sagemaker_notebook_instance_root_access_check`
- ✅ `secretmanager.1`: `secrets_should_have_automatic_rotation_enabled`
- ✅ `secretmanager.2`: `secrets_configured_with_automatic_rotation_should_rotate_successfully`
- ✅ `secretmanager.3`: `remove_unused_secrets_manager_secrets`
- ✅ `secretmanager.4`: `secrets_should_be_rotated_within_a_specified_number_of_days`
- ✅ `sns.1`: `sns_topics_should_be_encrypted_at_rest_using_aws_kms`
- ✅ `sns.2`: `sns_topics_should_have_message_delivery_notification_enabled`
- ✅ `sqs.1`: `sqs_queues_should_be_encrypted_at_rest`
- ✅ `ssm.1`: `ec2_instances_should_be_managed_by_ssm`
- ✅ `ssm.2`: `instances_should_have_patch_compliance_status_of_compliant`
- ✅ `ssm.3`: `instances_should_have_association_compliance_status_of_compliant`
- ✅ `ssm.4`: `documents_should_not_be_public`
- ✅ `stepfunctions.1`: `step_functions_state_machine_logging_enabled`
- ✅ `waf.1`: `waf_web_acl_logging_should_be_enabled`
- ✅ `waf.2`: `waf_regional_rule_not_empty`
- ✅ `waf.3`: `waf_regional_rulegroup_not_empty`
- ✅ `waf.4`: `waf_regional_webacl_not_empty`
- ✅ `waf.6`: `waf_global_rule_not_empty`
- ✅ `waf.7`: `waf_global_rulegroup_not_empty`
- ✅ `waf.8`: `waf_global_webacl_not_empty`
- ✅ `waf.10`: `wafv2_webacl_not_empty`

##### `imds_v2`

- ✅ `AMIs-IMDSv2`: `images_imdsv2_required`
- ✅ `EC2-IMDSv2`: `ec2_not_imdsv2_instances`
- ✅ `Lightsail-IMDSv2`: `lightsail_not_imdsv2_instances`

##### `pci_dss_v3.2.1`

- ✅ `autoscaling.1`: `autoscaling_groups_elb_check`
- ✅ `cloudtrail.1`: `logs_encrypted`
- ✅ `cloudtrail.2`: `cloudtrail_enabled_all_regions`
- ✅ `cloudtrail.3`: `log_file_validation_enabled`
- ✅ `cloudtrail.4`: `integrated_with_cloudwatch_logs`
- ✅ `cloudwatch.1`: `alarm_root_account`
- ✅ `codebuild.1`: `check_oauth_usage_for_sources`
- ✅ `codebuild.2`: `check_environment_variables`
- ✅ `config.1`: `config_enabled_all_regions`
- ✅ `dms.1`: `replication_not_public`
- ✅ `ec2.1`: `ebs_snapshot_permissions_check`
- ✅ `ec2.2`: `default_sg_no_access`
- ✅ `ec2.4`: `get_unused_public_ips`
- ✅ `ec2.5`: `no_broad_public_ingress_on_port_22`
- ✅ `ec2.6`: `flow_logs_enabled_in_all_vpcs`
- ✅ `elasticsearch.1`: `elasticsearch_domains_should_be_in_vpc`
- ✅ `elasticsearch.2`: `elasticsearch_domains_should_have_encryption_at_rest_enabled`
- ✅ `elbv2.1`: `elbv2_redirect_http_to_https`
- ✅ `guardduty enabled in all enabled regions`: `detector_enabled`
- ✅ `iam.1`: `root_user_no_access_keys`
- ✅ `iam.2`: `policies_attached_to_groups_roles`
- ✅ `iam.3`: `no_star`
- ✅ `iam.4`: `hardware_mfa_enabled_for_root`
- ✅ `iam.5`: `mfa_enabled_for_root`
- ✅ `iam.6`: `mfa_enabled_for_console_access`
- ✅ `iam.7`: `unused_creds_disabled`
- ✅ `iam.8`: `password_policy_strong`
- ✅ `kms.1`: `rotation_enabled_for_customer_key`
- ✅ `lambda.1`: `lambda_function_prohibit_public_access`
- ✅ `lambda.2`: `lambda_function_in_vpc`
- ✅ `rds.1`: `snapshots_should_prohibit_public_access`
- ✅ `rds.2`: `rds_db_instances_should_prohibit_public_access`
- ✅ `redshift.1`: `cluster_publicly_accessible`
- ✅ `s3.1`: `publicly_writable_buckets`
- ✅ `s3.2`: `publicly_readable_buckets`
- ✅ `s3.3`: `s3_cross_region_replication`
- ✅ `s3.4`: `s3_server_side_encryption_enabled`
- ✅ `s3.5`: `deny_http_requests`
- ✅ `s3.6`: `account_level_public_access_blocks`
- ✅ `sagemaker.1`: `sagemaker_notebook_instance_direct_internet_access_disabled`
- ✅ `secretmanager.1`: `secrets_should_have_automatic_rotation_enabled`
- ✅ `secretmanager.2`: `secrets_configured_with_automatic_rotation_should_rotate_successfully`
- ✅ `secretmanager.3`: `remove_unused_secrets_manager_secrets`
- ✅ `secretmanager.4`: `secrets_should_be_rotated_within_a_specified_number_of_days`
- ✅ `ssm.1`: `instances_should_have_patch_compliance_status_of_compliant`
- ✅ `ssm.2`: `instances_should_have_association_compliance_status_of_compliant`
- ✅ `ssm.3`: `ec2_instances_should_be_managed_by_ssm`
- ✅ `waf.1`: `wafv2_web_acl_logging_should_be_enabled`

##### `public_egress`

- ✅ `ec2-all-instances-with-routes-and-security-groups`: `public_egress_sg_and_routing_instances`
- ✅ `ec2-instances`: `public_egress_sg_instances`
- ✅ `lambda-functions`: `functions_with_public_egress`

##### `publicly_available`

- ✅ `API-Gateway-V2`: `api_gw_v2_publicly_accessible`
- ✅ `API-Gateways`: `api_gw_publicly_accessible`
- ✅ `CloudFront-Distributions`: `all_distributions`
- ✅ `EC2-Public-Ips`: `public_ips`
- ✅ `ELB-Classic`: `elbv1_internet_facing`
- ✅ `ELB-V2`: `elbv2_internet_facing`
- ✅ `RDS`: `rds_db_instances_should_prohibit_public_access`
- ✅ `Redshift`: `cluster_publicly_accessible`
<!-- AUTO-GENERATED-INCLUDED-CHECKS-END -->


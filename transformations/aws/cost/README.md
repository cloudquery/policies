# AWS Cost Policy

Welcome to AWS Cost Policy, a comprehensive solution designed to help you analyze and optimize your AWS spending. By leveraging CloudQuery, Cost and Usage Report, and DBT, AWS Cost Policy provides insightful views into your AWS usage and costs, identifying under-utilized resources, and allocating costs based on tags. This tool is ideal for cloud engineers, finance teams, and anyone looking to gain better visibility into their AWS costs.

## Prerequisites

Before you begin, ensure you have the following:
- An active AWS account with cost and usage report activated. [Creating a Cost and Usage Report](https://docs.aws.amazon.com/cur/latest/userguide/cur-create.html)
- CloudQuery CLI downloaded and installed. [Installing CloudQuery CLI](https://docs.cloudquery.io/docs)
- DBT CLI downloaded installed and configured. [Installing DBT CLI](https://docs.getdbt.com/docs/core/pip-install)
- A CloudQuery account. [Register to CloudQuery](https://www.cloudquery.io/auth/register?returnTo=%2Fz)
- A Postgresql instance running (Local or cloud based). [Running Postgres with Docker](https://www.docker.com/blog/how-to-use-the-postgres-docker-official-image/)
- Basic familiarity with YAML and SQL.


## To run the policy you need to complete the following steps
### Setting up the DBT profile
First, [install `dbt`](https://docs.getdbt.com/docs/core/pip-install):
```bash
pip install dbt-postgres
```

Create the profile directory:

```bash
mkdir -p ~/.dbt
```

Create a `profiles.yml` file in your profile directory (e.g. `~/.dbt/profiles.yml`):

```yaml
aws_cost: # This should match the name in your dbt_project.yml
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
`cloudquery login` in your terminal

### Syncing the Cost and Usage Report
Using the S3 Plugin and the Postgres Plugin sync the CUR file, you can use this example config yaml but make sure to fill the necessary values
```yml
  kind: source
  spec:
    name: s3-cur # The type of source, in this case, a s3-cur source.
    path: cloudquery/s3 # The plugin path for handling s3 sources.
    registry: cloudquery # The registry from which the plugin is sourced.
    version: "v1.0.1" # The version of the s3 plugin.
    tables: ["*"] # Specifies that all tables in the source should be considered.
    destinations: ["postgresql"] # The destination for the data, in this case, PostgreSQL.
    spec:
      bucket: "<BUCKET_NAME>"
      region: "<REGION>" 
      # path_prefix: "" # Optional. Only sync files with this prefix
      # concurrency: 50 # Optional. Defines the number of files to sync in parallel. Defaults to 50 if not set.

  ---
  kind: destination
  spec:
    name: "postgresql" # The type of destination, in this case, PostgreSQL.
    path: "cloudquery/postgresql" # The plugin path for handling PostgreSQL as a destination.
    registry: "cloudquery" # The registry from which the PostgreSQL plugin is sourced.
    version: "v7.3.5" # The version of the PostgreSQL plugin.
  spec:
      connection_string: "${POSTGRESQL_CONNECTION_STRING}"  # set the environment variable in a format like 
      # postgresql://postgres:pass@localhost:5432/postgres?sslmode=disable
      # You can also specify the connection string in DSN format, which allows for special characters in the password:
      # connection_string: "user=postgres password=pass+0-[word host=localhost port=5432 dbname=postgres"
```

### Syncing AWS data
Based on the models you are interested in running you need to sync the relevant tables
this is an example sync for the relevant tables for all the models (views) in the policy

*Do note* you will have to configure the cloudwatch spec to suit your data

```yml
kind: source
spec:
  name: aws # The source type, in this case, AWS.
  path: cloudquery/aws # The plugin path for handling AWS sources.
  registry: cloudquery # The registry from which the AWS plugin is sourced.
  version: "v24.3.2" # The version of the AWS plugin.
  tables: ["aws_cloudwatch_metrics", "aws_cloudwatch_metric_statistics", "aws_ec2_instances", "aws_rds_instances", "aws_cloudhsmv2_backups", "aws_docdb_cluster_snapshots", "aws_dynamodb_backups", "aws_dynamodb_table_continuous_backups", "aws_ec2_ebs_snapshots", "aws_elasticache_snapshots", "aws_fsx_backups", "aws_fsx_snapshots", "aws_lightsail_database_snapshots", "aws_lightsail_disk_snapshots", "aws_lightsail_instance_snapshots", "aws_neptune_cluster_snapshots", "aws_rds_cluster_snapshots", "aws_rds_db_snapshots", "aws_redshift_snapshots", "aws_computeoptimizer_autoscaling_group_recommendations", "aws_autoscaling_groups", "aws_computeoptimizer_ebs_volume_recommendations", "aws_computeoptimizer_ec2_instance_recommendations", "aws_ec2_instances", "aws_computeoptimizer_ecs_service_recommendations", "aws_ecs_cluster_services", "aws_computeoptimizer_lambda_function_recommendations", "aws_lambda_functions", "aws_acm_certificates", "aws_backup_vaults", "aws_cloudfront_distributions", "aws_directconnect_connections", "aws_dynamodb_tables", "aws_ec2_ebs_volumes", "aws_ec2_eips", "aws_ec2_hosts", "aws_ec2_images", "aws_ec2_internet_gateways", "aws_ec2_network_acls", "aws_ec2_transit_gateways", "aws_ec2_transit_gateway_attachments", "aws_ecr_repositories", "aws_ecr_repository_images", "aws_efs_filesystems", "aws_lightsail_container_service_deployments", "aws_lightsail_container_services", "aws_lightsail_disks", "aws_lightsail_distributions", "aws_lightsail_load_balancers", "aws_lightsail_static_ips", "aws_elbv2_listeners", "aws_elbv2_target_groups", "aws_elbv2_load_balancers", "aws_route53_hosted_zones", "aws_sns_subscriptions", "aws_sns_topics", "aws_support_trusted_advisor_checks", "aws_support_trusted_advisor_check_results"]
  destinations: ["postgresql"] # The destination for the data, in this case, PostgreSQL.
  use_paid_apis: true
  skip_dependent_tables: true
  spec:
    table_options:
      aws_cloudwatch_metrics:
        - list_metrics:
            namespace: AWS/RDS # Specifies the AWS service namespace for RDS metrics.
          get_metric_statistics:
            - period: 300 # The granularity, in seconds, of the returned data points.
              start_time: <YOUR_START_TIME> # The starting point for the data collection. example: 2024-01-01T00:00:01Z
              end_time: <YOUR END TIME> # The ending point for the data collection. example: 2024-01-30T23:59:59Z
              statistics: ["Average", "Maximum", "Minimum"] # The statistical values to retrieve.
        - list_metrics:
            namespace: AWS/EC2 # Specifies the AWS service namespace for EC2 metrics.
          get_metric_statistics:
            - period: 300 # The granularity, in seconds, of the returned data points.
              start_time: <YOUR_START_TIME> # The starting point for the data collection. example: 2024-01-01T00:00:01Z
              end_time: <YOUR END TIME> # The ending point for the data collection. example: 2024-01-30T23:59:59Z
              statistics: ["Average", "Maximum", "Minimum"] # The statistical values to retrieve.

---
kind: destination
spec:
  name: "postgresql" # The type of destination, in this case, PostgreSQL.
  path: "cloudquery/postgresql" # The plugin path for handling PostgreSQL as a destination.
  registry: "cloudquery" # The registry from which the PostgreSQL plugin is sourced.
  version: "v7.3.5" # The version of the PostgreSQL plugin.

  spec:
    connection_string: "${POSTGRESQL_CONNECTION_STRING}"  # set the environment variable in a format like 
    # postgresql://postgres:pass@localhost:5432/postgres?sslmode=disable
    # You can also specify the connection string in DSN format, which allows for special characters in the password:
    # connection_string: "user=postgres password=pass+0-[word host=localhost port=5432 dbname=postgres"

```

### Running the Policy
To run this policy you need to specify the name of the cost and usage report in your database, if you used the file plugin to load the report the table name will be the same as the file name (without the file extension).
Navigate to your dbt project directory, where your `dbt_project.yml` resides.

Before executing the `dbt run` command, it might be useful to check for any potential issues:

```bash
dbt compile --vars '{"cost_usage_table": "<cost_and_usage_report>"}'
```

If everything compiles without errors, you can then execute:

```bash
dbt run --vars '{"cost_usage_table": "<cost_and_usage_report>"}'
```

To run specific models

```bash
dbt run --vars '{"cost_usage_table": "<cost_and_usage_report>"}' --select aws_cost__by_regions aws_cost__by_resources
```


## Usage Examples

### Top 10 Most Cost Consuming Under-Utilized Resources
To quickly identify which resources are both under-utilized and consuming a significant portion of your budget, use the following query:
```sql
SELECT service, arn, cost
FROM aws_cost__by_under_utilized_resources
ORDER BY cost DESC
LIMIT 10;
```
### Most Cost Consuming Resource Types for Unused Resources
To uncover resources that are no longer in use but still incurring costs, facilitating decisions on resource cleanup:
```sql
SELECT resource_type, SUM(cost) AS total_cost
FROM aws_cost__of_unused_resources
GROUP BY resource_type
ORDER BY total_cost DESC;
```
### Cost Allocation by CloudFormation Tags
For organizations utilizing AWS CloudFormation, understanding cost distribution across different stacks is crucial:
```sql
SELECT cloudformation_stack_name, SUM(sum_line_item_unblended_cost) AS total_cost
FROM aws_cost__cloudformation_tag_spend_allocation
GROUP BY cloudformation_stack_name
ORDER BY total_cost DESC;
```
### ECS Service Cost Optimization Opportunities
Identify ECS services that may benefit from optimization to reduce costs without compromising on performance:
```sql
SELECT service_name, region, current_performance_risk, finding, recommended_performance_risk, cost
FROM ecs_service_optimization_recommendations
WHERE finding = 'Over-provisioned'
ORDER BY cost DESC;
```
### Lambda Functions with Optimization Potential
Spot Lambda functions that might be running with more memory than required, indicating an opportunity for cost savings:
```sql
SELECT function_name, region, current_memory_size, recommend_memory_size, number_of_invocations, cost
FROM lambda_function_optimization_recommendations
WHERE current_memory_size > recommend_memory_size
ORDER BY cost DESC;
```
### Insights into Trusted Advisor Cost Optimization Recommendations
Gain insights from AWS Trusted Advisor's cost optimization checks to further reduce expenses:
```sql
SELECT name, description, category, arn, account_id
FROM aws_cost__trusted_advisor_by_arn
ORDER BY account_id, arn;
```

## Data Dictionary
In this section you can see all the models (views) that are included in the policy with an explanation about the data inside and the columns available.
cost will be in the same units as it is in the CUR file which are USD ($).
line_item_resource_id is usually the resource ARN except in certain cases where it is a volume_id or instance_id of certain services.
By default the models related to tags are disabled (Tags  are only available in the CUR if they are activated), to enable this model change them to enabled in the models section in `dbt_project.yml`

#### `aws_cost__by_under_utilized_resources`
Identifies resources that are under-utilized based on specific metrics (e.g., CPUUtilization, storage usage), highlighting opportunities for cost optimization. Supported services include EC2 Instances, RDS Clusters, and DynamoDB.

- `arn` - The resource identifier.
- `service` - The AWS service (e.g., EC2, RDS).
- `instance_type` - The type of instance (e.g., t3.mini).
- `metric` - The metric indicating under-utilization.
- `value` - The value for the metric (Usually percentage %).
- `cost` - The cost of the resource.

#### `aws_cost__of_unused_resources`
Identifies resources and are completely unused (not metric based), highlighting 'To Be Deleted' resources.
Supported services are acm certs, backup vaults, cloudfront distributions, directconnect connections, dynamodb tables, ec2 ebs volumes, ec2 eips, ec2 internet gateways, ec2 hosts, ec2 images, ec2 network acls, ec2 transit gateways, ecr repositories, efs filesystems, lightsail container services, lightsail disks, lightsail distributions, lightsail load balancers, lightsail static ips, load balancers, route53 hosted zones, sns topics.

- `account_id` - the account that owns the resource.
- `resource_id` - the arn of the resource
- `cost` - the total cost of the resource
- `resource_type` - the type of resource (i.e lightsail load balancer)

#### `aws_cost__cloudformation_tag_spend_allocation`
Provides a breakdown of costs by CloudFormation tags, helping in cost allocation and chargeback calculations.

- `cloudformation_logical_id` - Identifier for the CloudFormation resource.
- `cloudformation_stack_name` - Name of the CloudFormation stack.
- `month` - The billing period month.
- `sum_line_item_unblended_cost` - Raw cost per CloudFormation tag group.
- `sum_spend` - Total spend for all resources.
- `untagged_spend` - Spend allocated to untagged resources.
- `tagged_spend` - Spend allocated to tagged resources.
- `percent_spend` - Percentage of spend per tag group.
- `untagged_cost_distribution` - Percentage of spend for untagged resources.
- `chargeback` - Chargeback amount for tagged resources.

#### `aws_cost__by_cloudformation_tag`
Focuses on cost allocation for resources tagged with CloudFormation tags.

- `cloudformation_logical_id` - Identifier for the CloudFormation resource.
- `cloudformation_stack_name` - Name of the CloudFormation stack.
- `month` - The billing period month.
- `sum_line_item_unblended_cost` - Raw cost per CloudFormation tag group.

#### `aws_cost__beanstalk_tag_spend_allocation`
Analyzes costs associated with Elastic Beanstalk environments, aiding in understanding spend distribution across tagged and untagged resources.

- `elasticbeanstalk_environment_id` - Identifier for the Elastic Beanstalk environment.
- `month` - The billing period month.
- `sum_line_item_unblended_cost` - Raw cost per Elastic Beanstalk tag group.
- `sum_spend` - Total spend for all resources.
- `untagged_spend` - Spend allocated to untagged resources.
- `tagged_spend` - Spend allocated to tagged resources.
- `percent_spend` - Percentage of spend per tag group.
- `untagged_cost_distribution` - Percentage of spend for untagged resources.
- `chargeback` - Chargeback amount for tagged resources.

#### `aws_cost__by_beanstalk_tag`
Details cost allocation for Elastic Beanstalk tagged resources.

- `elasticbeanstalk_environment_id` - Identifier for the Elastic Beanstalk environment.
- `month` - The billing period month.
- `sum_line_item_unblended_cost` - Raw cost per Elastic Beanstalk tag.

#### `aws_cost__ecs_tag_spend_allocation`
Offers insights into costs by ECS cluster tags, facilitating detailed spend analysis and chargeback for ECS resources.

- `ecs_cluster` - Identifier for the ECS cluster.
- `month` - The billing period month.
- `sum_line_item_unblended_cost` - Raw cost per ECS cluster tag group.
- `sum_spend` - Total spend for all resources.
- `untagged_spend` - Spend allocated to untagged resources.
- `tagged_spend` - Spend allocated to tagged resources.
- `percent_spend` - Percentage of spend per tag group.
- `untagged_cost_distribution` - Percentage of spend for untagged resources.
- `chargeback` - Chargeback amount for tagged resources.

#### `aws_cost__by_ecs_tag`
Concentrates on cost breakdown for resources tagged within ECS clusters.

- `ecs_cluster` - Identifier for the ECS cluster.
- `month` - The billing period month.
- `sum_line_item_unblended_cost` - Raw cost per ECS tag.

#### `aws_cost__lambda_tag_spend_allocation`
Breaks down Lambda function costs by tags, aiding in the management and allocation of Lambda-related expenses.

- `lambda_function_name` - Identifier for the Lambda function.
- `month` - The billing period month.
- `sum_line_item_unblended_cost` - Raw cost per Lambda tag groups.
- `sum_spend` - Total spend for all resources.
- `untagged_spend` - Spend allocated to untagged resources.
- `tagged_spend` - Spend allocated to tagged resources.
- `percent_spend` - Percentage of spend per tag group.
- `untagged_cost_distribution` - Percentage of spend for untagged resources.
- `chargeback` - Chargeback amount for tagged resources.

#### `aws_cost__by_lambda_tag`
Details cost allocation for Lambda functions based on tagging.

- `lambda_function_name` - Identifier for the Lambda function.
- `month` - The billing period month.
- `sum_line_item_unblended_cost` - Raw cost per Lambda tag.

#### `aws_cost__by_tag`
General view for analyzing costs by AWS tags, facilitating broad cost management across different AWS resources.

- `aws_tag_name` - The name of the AWS tag.
- `aws_tag_value` - The value of the AWS tag.
- `month` - The billing period month.
- `sum_line_item_unblended_cost` - Sum of the raw cost per tag.

#### `aws_cost__by_untagged_resource`
Highlights costs associated with untagged resources, offering insights into potential areas for cost optimization through better resource tagging.

- `account_id` - AWS account ID.
- `resource_id` - Identifier for the resource.
- `service` - The AWS service name.
- `month` - The billing period month.
- `sum_line_item_unblended_cost` - Sum of the raw cost per untagged resource.

#### `aws_cost__by_recovery_resources`
Provides insights into the cost associated with recovery resources.
- `account_id` - The account ID that owns the resource.
- `resource_id` - The identifier of the resource.
- `cost` - The cost associated with the resource.
- `resource_type` - The type of the resource, e.g., `rds_db_snapshots`.

#### `autoscaling_group_optimization_recommendations`
Offers recommendations for optimizing Auto Scaling Groups.
- `account_id` - The account ID that owns the Auto Scaling Group resource.
- `auto_scaling_group_arn` - The Amazon Resource Name (ARN) of the Auto Scaling Group.
- `auto_scaling_group_name` - The name of the Auto Scaling Group.
- `region` - The region where the Auto Scaling Group is located.
- `status` - The status of the Auto Scaling Group.
- `current_performance_risk` - The current performance risk of the Auto Scaling Group.
- `finding` - The finding classification of the Auto Scaling Group.
- `inferred_workload_types` - The inferred workload types running on the Auto Scaling Group.
- `current_desired_capacity` - The current desired capacity configuration of the Auto Scaling Group.
- `recommended_desired_capacity` - The recommended desired capacity configuration of the Auto Scaling Group.
- `current_instance_type` - The current instance type configuration of the Auto Scaling Group.
- `recommended_instance_type` - The recommended instance type configuration of the Auto Scaling Group.
- `current_max_size` - The current maximum size configuration of the Auto Scaling Group.
- `recommended_max_size` - The recommended maximum size configuration of the Auto Scaling Group.
- `current_min_size` - The current minimum size configuration of the Auto Scaling Group.
- `recommended_min_size` - The recommended minimum size configuration of the Auto Scaling Group.
- `current_gpus` - The number of GPUs (if any) in the current configuration of the Auto Scaling Group.
- `recommended_gpus` - The number of GPUs (if any) in the recommended configuration of the Auto Scaling Group.
- `migration_effort` - The level of effort required for migrating to the recommended configuration.
- `recommended_performance_risk` - The performance risk of the recommended configuration of the Auto Scaling Group.
- `cost` - The cost associated with the Auto Scaling Group.

#### `ebs_volume_optimization_recommendations`
Analyzes EBS volumes to provide recommendations for optimizing performance and cost.
- `account_id` - The account ID that owns the EBS volume resource.
- `volume_arn` - The Amazon Resource Name (ARN) of the EBS volume.
- `ecs_attached` - Indicates if the EBS volume is attached to an ECS container instance.
- `encrypted` - Indicates if the EBS volume is encrypted.
- `fast_restored` - Indicates if the EBS volume was fast restored.
- `availability_zone` - The availability zone where the EBS volume is located.
- `region` - The region where the EBS volume is located.
- `state` - The state of the EBS volume.
- `snapshot_id` - The ID of the snapshot associated with the EBS volume.
- `sse_type` - The type of server-side encryption (SSE) used for the EBS volume.
- `current_performance_risk` - The current performance risk of the EBS volume.
- `finding` - The finding classification of the EBS volume.
- `current_baseline_iops` - The current baseline IOPS configuration of the EBS volume.
- `recommended_baseline_iops` - The recommended baseline IOPS configuration of the EBS volume.
- `current_baseline_throughput` - The current baseline throughput configuration of the EBS volume.
- `recommended_baseline_throughput` - The recommended baseline throughput configuration of the EBS volume.
- `current_burst_iops` - The current burst IOPS configuration of the EBS volume.
- `recommended_burst_iops` - The recommended burst IOPS configuration of the EBS volume.
- `current_burst_throughput` - The current burst throughput configuration of the EBS volume.
- `recommended_burst_throughput` - The recommended burst throughput configuration of the EBS volume.
- `current_volume_size` - The current size of the EBS volume.
- `recommended_volume_size` - The recommended size of the EBS volume.
- `current_volume_type` - The current volume type of the EBS volume.
- `recommended_volume_type` - The recommended volume type of the EBS volume.
- `recommended_performance_risk` - The performance risk of the recommended configuration of the EBS volume.
- `cost` - The cost associated with the EBS volume.

#### `ec2_instances_optimization_recommendations`
Provides optimization recommendations for EC2 instances.
- `account_id` - The account ID that owns the EC2 instance resource.
- `instance_arn` - The Amazon Resource Name (ARN) of the EC2 instance.
- `region` - The region where the EC2 instance is located.
- `state` - The state of the EC2 instance.
- `tags` - The tags associated with the EC2 instance.
- `instance_type` - The instance type of the EC2 instance.
- `architecture` - The architecture of the EC2 instance.
- `ami_launch_index` - The AMI launch index of the EC2 instance.
- `private_ip_address` - The private IP address of the EC2 instance.
- `ipv6_address` - The IPv6 address of the EC2 instance.
- `current_performance_risk` - The current performance risk of the EC2 instance.
- `current_gpus` - The number of GPUs of the current EC2 instance.
- `recommended_gpus` - The number of GPUs recommended for the EC2 instance.
- `current_instance_type` - The current instance type of the EC2 instance.
- `recommended_instance_type` - The recommended instance type for the EC2 instance.
- `migration_effort` - The level of effort required for migrating to the recommended instance type.
- `recommended_performance_risk` - The performance risk of the recommended instance type.
- `platform_differences` - The platform differences between the current and recommended instance types.
- `cost` - The cost associated with the EC2 instance.

#### `ecs_service_optimization_recommendations`
Targets ECS services for optimization.
- `account_id` - The account ID that owns the ECS service.
- `service_arn` - The Amazon Resource Name (ARN) of the ECS service.
- `service_name` - The name of the ECS service.
- `region` - The region where the ECS service is located.
- `current_performance_risk` - The current performance risk of the ECS service.
- `finding` - The finding classification of the ECS service.
- `finding_reason_codes` - The reason codes for the finding classification of the ECS service.
- `container_cpu_recommendation` - The CPU recommendation for the container in the ECS service.
- `container_memory_size_recommendation` - The memory size recommendation for the container in the ECS service.
- `status` - The status of the ECS service.
- `tags` - The tags associated with the ECS service.
- `cluster_arn` - The ARN of the ECS cluster to which the service belongs.
- `desired_count` - The desired count of tasks for the ECS service.
- `launch_type` - The launch type of the ECS service.
- `load_balancers` - The load balancers associated with the ECS service.
- `platform_family` - The platform family of the ECS service.
- `platform_version` - The platform version of the ECS service.
- `running_count` - The number of tasks running for the ECS service.
- `cost` - The cost associated with the ECS service.

#### `lambda_function_optimization_recommendations`
Provides optimization recommendations for Lambda functions.
- `account_id` - The account ID that owns the Lambda function.
- `function_arn` - The Amazon Resource Name (ARN) of the Lambda function.
- `function_name` - The name of the Lambda function.
- `region` - The region where the Lambda function is located.
- `tags` - The tags associated with the Lambda function.
- `function_version` - The version of the Lambda function.
- `code_size` - The size of the Lambda function's code.
- `lookback_period_in_days` - The number of days for which utilization metrics were analyzed for the Lambda function.
- `number_of_invocations` - The number of invocations of the Lambda function.
- `current_performance_risk` - The current performance risk of the Lambda function.
- `finding` - The finding classification of the Lambda function.
- `finding_reason_codes` - The reason codes for the finding classification of the Lambda function.
- `current_memory_size` - The current memory size configuration of the Lambda function.
- `recommend_memory_size` - The recommended memory size for the Lambda function.

#### `aws_cost__trusted_advisor_by_arn`
This view aggregates data from AWS Trusted Advisor checks specifically related to cost optimization. It joins information about the checks with the resources they flag, providing a focused view on areas where cost efficiency can be improved.

- `account_id` - The AWS account ID that owns the resource. This field helps identify which account a particular piece of advice applies to, making it easier for organizations with multiple accounts to allocate advice to the correct account.
- `arn` - The Amazon Resource Name (ARN) of the resource. ARNs are unique identifiers for AWS resources and here they specify exactly which resource the Trusted Advisor check is referring to.
- `category` - The category of the Trusted Advisor check. In this view, it will always be 'cost_optimizing', indicating that the advice is aimed at improving cost efficiency.
- `id` - The ID of the Trusted Advisor check. This is a unique identifier for each type of check that Trusted Advisor performs, allowing users to reference the specific advice or test being applied.
- `name` - The name of the Trusted Advisor check. This provides a human-readable description of what the check is about, such as "Low Utilization Amazon EC2 Instances".
- `description` - The description of the Trusted Advisor check. This field offers more detailed information about what the check entails and possibly how to address the advice given.

### `aws_cost__anomaly_per_service`
Identifies resources within an AWS service that have costs considered statistically anomalous compared to other resources in the same service.
- `line_item_product_code` - The AWS service.
- `line_item_resource_id` - The resource ARN.
- `cost` - The total cost of the resource.
- `mean_cost` - The average cost for the service (`product_code`).
- `std_cost` - The standard deviation of the cost for the service (`product_code`).

### `aws_cost__by_account`
Aggregates costs by account.
- `line_item_usage_account_id` - The account that incurred the cost.
- `cost` - The total cost for the account.

### `aws_cost__by_region`
Aggregates costs by region.
- `product_location` - The region where the resource is located.
- `cost` - The total cost for the region.

### `aws_cost__by_resource`
Aggregates costs by resource.
- `line_item_resource_id` - The resource ARN.
- `line_item_product_code` - The AWS service.
- `cost` - The total cost of the resource.

### `aws_cost__by_product`
Aggregates costs by AWS Product.
- `line_item_product_code` - The AWS product (i.e EC2, RDS).
- `cost` - The total cost for the region.

### `aws_cost__gp2_ebs_volumes`
Details the cost of GP2 EBS volumes.
- `line_item_resource_id` - The resource ID.
- `cost` - The total cost of the resource.
- `volume_type` - The volume type.
- `attachments` - The number of attachments.
- `arn` - The resource ARN.
- `tags` - The tags associated with the volume.
- `state` - The state of the volume.
- `snapshot_id` - The snapshot ID.
- `size` - The volume size.
- `create_time` - The volume creation time.

### `aws_cost__over_time`
Aggregates cost by time period.
- `line_item_usage_start_date` - The start date of the billing period.
- `line_item_usage_end_date` - The end date of the billing period.
- `cost` - The total cost in the time period.


## Required Tables By Model (View)

### `aws_cost__by_under_utilized_resources`
- `cost table`
- `aws_cloudwatch_metrics`
- `aws_cloudwatch_metric_statistics`
- `aws_ec2_instances`
- `aws_rds_instances`

### `aws_cost__by_recovery_resources`
- `cost table`
- `aws_cloudhsmv2_backups`
- `aws_docdb_cluster_snapshots`
- `aws_dynamodb_backups`
- `aws_dynamodb_table_continuous_backups`
- `aws_ec2_ebs_snapshots`
- `aws_elasticache_snapshots`
- `aws_fsx_backups`
- `aws_fsx_snapshots`
- `aws_lightsail_database_snapshots`
- `aws_lightsail_disk_snapshots`
- `aws_lightsail_instance_snapshots`
- `aws_neptune_cluster_snapshots`
- `aws_rds_cluster_snapshots`
- `aws_rds_db_snapshots`
- `aws_redshift_snapshots`

### `compute_optimizer`
- **Autoscaling Group**
  - `aws_computeoptimizer_autoscaling_group_recommendations`
  - `aws_autoscaling_groups`
- **EC2 EBS Volumes**
  - `aws_computeoptimizer_ebs_volume_recommendations`
  - `aws_ec2_ebs_volumes`
- **EC2 Instances**
  - `aws_computeoptimizer_ec2_instance_recommendations`
  - `aws_ec2_instances`
- **ECS Cluster Service**
  - `aws_computeoptimizer_ecs_service_recommendations`
  - `aws_ecs_cluster_services`
- **Lambda Function**
  - `aws_computeoptimizer_lambda_function_recommendations`
  - `aws_lambda_functions`

### `aws_cost__by_unused_resources`
- `cost table`
- `aws_cost__by_resource`
- `aws_acm_certificates`
- `aws_backup_vaults`
- `aws_cloudfront_distributions`
- `aws_directconnect_connections`
- `aws_dynamodb_tables`
- `aws_ec2_ebs_volumes`
- `aws_ec2_eips`
- `aws_ec2_hosts`
- `aws_ec2_images`
- `aws_ec2_internet_gateways`
- `aws_ec2_network_acls`
- `aws_ec2_transit_gateways`
- `aws_ec2_transit_gateway_attachments`
- `aws_ecr_repositories`
- `aws_ecr_repository_images`
- `aws_efs_filesystems`
- `aws_lightsail_container_service_deployments`
- `aws_lightsail_container_services`
- `aws_lightsail_disks`
- `aws_lightsail_distributions`
- `aws_lightsail_load_balancers`
- `aws_lightsail_static_ips`
- `aws_elbv2_listeners`
- `aws_elbv2_target_groups`
- `aws_elbv2_load_balancers`
- `aws_route53_hosted_zones`
- `aws_sns_subscriptions`
- `aws_sns_topics`

### `aws_cost__cloudformation_tag_spend_allocation`
- `cost table`

### `aws_cost__by_cloudformation_tag`
- `cost table`

### `aws_cost__beanstalk_tag_spend_allocation`
- `cost table`

### `aws_cost__by_beanstalk_tag`
- `cost table`

### `aws_cost__ecs_tag_spend_allocation`
- `cost table`

### `aws_cost__by_ecs_tag`
- `cost table`

### `aws_cost__lambda_tag_spend_allocation`
- `cost table`

### `aws_cost__by_lambda_tag`
- `cost table`

### `aws_cost__by_tag`
- `cost table`

### `aws_cost__by_untagged_resource`
- `cost table`

### `autoscaling_group_optimization_recommendations`
- `cost table`
- `aws_computeoptimizer_autoscaling_group_recommendations`
- `aws_autoscaling_groups`

### `ebs_volume_optimization_recommendations`
- `cost table`
- `aws_computeoptimizer_ebs_volume_recommendations`
- `aws_ec2_ebs_volumes`

### `ec2_instances_optimization_recommendations`
- `cost table`
- `aws_computeoptimizer_ec2_instance_recommendations`
- `aws_ec2_instances`

### `ecs_service_optimization_recommendations`
- `cost table`
- `aws_computeoptimizer_ecs_service_recommendations`
- `aws_ecs_cluster_services`

### `lambda_function_optimization_recommendations`
- `cost table`
- `aws_computeoptimizer_lambda_function_recommendations`
- `aws_lambda_functions`

### `aws_cost__trusted_advisor_by_arn`
- `aws_support_trusted_advisor_checks`
- `aws_support_trusted_advisor_check_results`- `


### `aws_cost__over_time`
- `cost table`

### `aws_cost__by_resource`
- `cost table`

### `aws_cost__by_region`
- `cost table`

### `aws_cost__by_account`
- `cost table`

### `aws_cost__by_product`
- `cost table`

### `aws_cost__anomaly_per_service`
- `cost table`

### `aws_cost__gcp2_ebs_volumes`
- `cost table`
- `aws_ec2_ebs_volumes`
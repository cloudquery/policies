# AWS Cost Policy (Free)

Welcome to AWS Cost Policy, a comprehensive solution designed to help you analyze and optimize your AWS spending. By leveraging CloudQuery, Cost and Usage Report, and DBT, AWS Cost Policy provides insightful views into your AWS usage and costs, identifying under-utilized resources, and allocating costs based on tags. This tool is ideal for cloud engineers, finance teams, and anyone looking to gain better visibility into their AWS costs.

## Prerequisites

Before you begin, ensure you have the following:
- An active AWS account with cost and usage report activated. [Creating a Cost and Usage Report](https://docs.aws.amazon.com/cur/latest/userguide/cur-create.html)
- CloudQuery CLI downloaded and installed. [Installing CloudQuery CLI](https://docs.cloudquery.io/docs)
- DBT CLI downloaded installed and configured. [Installing DBT CLI](https://docs.getdbt.com/docs/core/installation-overview)
- A CloudQuery account. [Register to CloudQuery](https://www.cloudquery.io/auth/register?returnTo=%2Fz)
- A Postgresql instance running (Local or cloud based). [Running Postgres with Docker](https://www.docker.com/blog/how-to-use-the-postgres-docker-official-image/)
- Basic familiarity with YAML and SQL.


## To run the policy you need to complete the following steps
### Setting up the DBT profile
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
1) Download you Cost and Usage Report from aws.
2) Using the File Plugin and the Postgres Plugin sync the CUR file, you can use this exanple config yaml but make sure to fill the necessary values
    ```yml
    kind: source
    spec:
    name: file # The type of source, in this case, a file source.
    path: cloudquery/file # The plugin path for handling file sources.
    registry: cloudquery # The registry from which the plugin is sourced.
    version: "v1.2.1" # The version of the file plugin.
    tables: ["*"] # Specifies that all tables in the source should be considered.
    destinations: ["postgresql"] # The destination for the data, in this case, PostgreSQL.

    spec:
        files_dir: "/path/to/files-to-sync" # The directory where the files to be synced are located.
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
dbt run --vars '{"cost_usage_table": "<cost_and_usage_report>"}'
```


## Usage Examples

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


## Data Dictionary
In this section you can see all the models (views) that are included in the policy with an explantaion about the data inside and the columns available.
cost will be in the same units as it is in the CUR file which are USD ($).
line_item_resource_id is usually the resource ARN except in certain cases where it is a volume_id or instance_id of certain services.
By default the models related to tags are disabled (Tags  are only available in the CUR if they are activated), to enable this model change them to enabled in the models section in `dbt_project.yml`

#### `aws_cost__of_unused_resources`
Identifies resources and are completely unused (not metric based), highlighting 'To Be Deleted' resources.
Supported services are acm certs, backup vaults, cloudfront dstributions, directconnect connections, dynamodb tables, ec2 ebs volumes, ec2 eips, ec2 internet gateways, ec2 hosts, ec2 images, ec2 network acls, ec2 transit gateways, ecr repositories, efs filesystems, lightsail container services, lightsail disks, lightsail distributions, lightsail load balancers, lightsail static ips, load balancers, route53 hosted zones, sns topics.

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


#### `aws_cost__by_recovery_resources`
Provides insights into the cost associated with recovery resources.
- `account_id` - The account ID that owns the resource.
- `resource_id` - The identifier of the resource.
- `cost` - The cost associated with the resource.
- `resource_type` - The type of the resource, e.g., `rds_db_snapshots`.


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

### `aws_cost__by_resource`
Aggregates costs by resource.
- `line_item_resource_id` - The resource ARN.
- `line_item_product_code` - The AWS service.
- `cost` - The total cost of the resource.

### `aws_cost__by_product`
Aggregates costs by AWS Product.
- `line_item_product_code` - The AWS product (i.e EC2, RDS).
- `cost` - The total cost for the region.


## Required Tables By Model (View)

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
- **ECS Cluster Service**
  - `aws_computeoptimizer_ecs_service_recommendations`
  - `aws_ecs_cluster_services`

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

### `aws_cost__by_resource`
- `cost table`

### `aws_cost__by_product`
- `cost table`

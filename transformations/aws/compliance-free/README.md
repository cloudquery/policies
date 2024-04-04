# CloudQuery &times; dbt: AWS Compliance Package (Free)

## Overview
Welcome to AWS Compliance Package (Free), a free compliance solution that works on top of the CloudQuery framework. This package offers automated checks across various AWS services, following benchmarks such as CIS and AWS foundational security standards.
Using this solution you can get instant insights about your security posture and make sure you are following the recommended security guidelines defined by AWS, CIS and more.

This package is a free version of the more comprehensive [AWS Compliance Package](https://hub.cloudquery.io/addons/transformation/cloudquery/aws-compliance-premium/latest/docs)

We recommend to use this transformation with our [AWS Compliance Dashboard](https://hub.cloudquery.io/addons/visualization/cloudquery/aws-compliance/latest/docs)
![AWS Compliace Dashboard](./images/dashboard_example.png)

### Examples
How can I check that all my API Gateway related resources are following the foundational security standards? (PostgreSQL)
```sql
SELECT *
FROM aws_compliance__foundational_security
WHERE check_id LIKE '%apigateway.%'
```

How many checks did I fail in the CIS 1.2.0 benchmark? (PostgreSQL)
```sql
SELECT count(*) as failed_count
FROM aws_compliance__cis_v1_2_0
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

One of the below databases

- [PostgreSQL](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql)
- [Snowflake](https://hub.cloudquery.io/plugins/destination/cloudquery/snowflake)
- [BigQuery](https://hub.cloudquery.io/plugins/destination/cloudquery/bigquery)

### What's in the pack

The pack contains the free version of the compliance package which includes some of the checks from the AWS Foundational Security benchmark, CIS 1.2.0 benchmark and more.

## To run this package you need to complete the following steps

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
`cloudquery login` in your terminal

### Syncing AWS data
Based on the models you are interested in running you need to sync the relevant tables
this is an example sync for the relevant tables for all the models (views) in the policy and with a postgres destination, this package also supports snowflake and bigquery



 ```yml
kind: source
spec:
  name: aws # The source type, in this case, AWS.
  path: cloudquery/aws # The plugin path for handling AWS sources.
  registry: cloudquery # The registry from which the AWS plugin is sourced.
  version: "v24.3.2" # The version of the AWS plugin.
  tables: ["aws_regions","aws_iam_password_policies","aws_cloudfront_distributions","aws_iam_accounts","aws_iam_credential_reports","aws_iam_users","aws_account_alternate_contacts","aws_elbv2_load_balancer_attributes","aws_apigateway_rest_api_stages","aws_codebuild_projects","aws_autoscaling_groups","aws_elbv1_load_balancers","aws_apigateway_rest_apis","aws_rds_clusters","aws_apigatewayv2_api_stages","aws_elasticbeanstalk_environments","aws_cloudtrail_trail_event_selectors","aws_efs_access_points","aws_elbv2_load_balancers","aws_apigatewayv2_apis","aws_config_configuration_recorders","aws_apigatewayv2_api_routes","aws_s3_accounts","aws_cloudtrail_trails","aws_iam_virtual_mfa_devices","aws_iam_user_access_keys"]
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

#### Running Your dbt Project

Navigate to your dbt project directory, where your `dbt_project.yml` resides. Make sure to have an existing profile in your `profiles.yml` that contains your snowflake connection and authentication information.

If everything compiles without errors, you can then execute:

```bash
dbt run
```

This command will run all your `dbt` models and create tables/views in your destination database as defined in your models.

**Note:** If running locally ensure you are using `dbt-core` and not `dbt-cloud-cli` as dbt-core does not require extra authentication

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

- **aws_compliance\_\_cis_v1_2_0_free**: AWS CIS V1.2.0 benchmark, available for PostgreSQL, Snowflake, and BigQuery
- **aws_compliance\_\_cis_v2_0_0_free**: AWS CIS V2.0.0 benchmark, available for PostgreSQL, Snowflake, and BigQuery
- **aws_compliance\_\_cis_v3_0_0_free**: AWS CIS V3.0.0 benchmark, available for PostgreSQL, Snowflake, and BigQuery
- **aws_compliance\_\_pci_dss_v3_2_1_free**: AWS PCI DSS V3.2.1 benchmark, PostgreSQL, Snowflake, and BigQuery   
- **aws_compliance\_\_foundational_security_free**: AWS Foundational Security benchmark, PostgreSQL, Snowflake, and BigQuery

The free version contains 10% of the full pack's checks.

All of the models contain the following columns:
- **framework**: The benchmark the check belongs to.
- **check_id**: The check identifier (either a number or the service name and numberr).
- **title**: The name/title of the check.
- **account_id**: The AWS account id.
- **resource_id**: The resource id (ARN).
- **status**: The status of the check (fail / pass).

### Required tables
- **aws_compliance\_\_cis_v1_2_0_free**:
```yaml
"aws_iam_password_policies",
"aws_iam_users",
"aws_iam_credential_reports",
"aws_iam_user_access_keys"
```
- **aws_compliance\_\_cis_v2_0_0_free**:
```yaml
"aws_iam_password_policies",
"aws_iam_accounts",
"aws_iam_credential_reports",
"aws_account_alternate_contacts",
"aws_iam_virtual_mfa_devices"
```
- **aws_compliance\_\_cis_v3_0_0_free**:
```yaml
"aws_iam_password_policies",
"aws_iam_accounts",
"aws_iam_credential_reports",
"aws_account_alternate_contacts",
"aws_iam_virtual_mfa_devices"
```
- **aws_compliance\_\_pci_dss_v3_2_1_free**:
```yaml
"aws_regions",
"aws_codebuild_projects",
"aws_autoscaling_groups",
"aws_cloudtrail_trail_event_selectors",
"aws_config_configuration_recorders",
"aws_cloudtrail_trails"
```
- **aws_compliance\_\_foundational_security_free**:
```yaml
"aws_cloudfront_distributions",
"aws_iam_accounts",
"aws_elbv2_load_balancer_attributes",
"aws_apigateway_rest_api_stages",
"aws_elbv1_load_balancers",
"aws_apigateway_rest_apis",
"aws_rds_clusters",
"aws_apigatewayv2_api_stages",
"aws_elasticbeanstalk_environments",
"aws_efs_access_points",
"aws_elbv2_load_balancers",
"aws_apigatewayv2_apis",
"aws_apigatewayv2_api_routes",
"aws_s3_accounts"
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

##### `cis_v2.0.0`

- ✅ `1.2`: `security_account_information_provided`
- ✅ `1.4`: `iam_root_user_no_access_keys`
- ✅ `1.5`: `mfa_enabled_for_root`
- ✅ `1.6`: `hardware_mfa_enabled_for_root`
- ✅ `1.7`: `iam_root_last_used`
- ✅ `1.8`: `password_policy_min_length`
- ✅ `1.9`: `password_policy_prevent_reuse`

##### `cis_v3.0.0`

- ✅ `1.2`: `security_account_information_provided`
- ✅ `1.4`: `iam_root_user_no_access_keys`
- ✅ `1.5`: `mfa_enabled_for_root`
- ✅ `1.6`: `hardware_mfa_enabled_for_root`
- ✅ `1.7`: `iam_root_last_used`
- ✅ `1.8`: `password_policy_min_length`
- ✅ `1.9`: `password_policy_prevent_reuse`

##### `foundational_security`

- ✅ `apigateway.1`: `api_gw_execution_logging_enabled`
- ✅ `apigateway.4`: `api_gw_associated_wth_waf`
- ✅ `apigateway.5`: `api_gw_cache_data_encrypted`
- ✅ `apigateway.8`: `api_gw_routes_should_specify_authorization_type`
- ✅ `apigateway.9`: `api_gw_access_logging_should_be_configured`
- ✅ `efs.3`: `access_point_path_should_not_be_root`
- ✅ `efs.4`: `access_point_enforce_user_identity`
- ✅ `elastic_beanstalk.1`: `advanced_health_reporting_enabled`
- ✅ `elb.4`: `alb_drop_http_headers`
- ✅ `elb.5`: `alb_logging_enabled`
- ✅ `elb.6`: `alb_deletion_protection_enabled`
- ✅ `rds.14`: `amazon_aurora_clusters_should_have_backtracking_enabled`
- ✅ `s3.1`: `account_level_public_access_blocks`

##### `pci_dss_v3.2.1`

- ✅ `autoscaling.1`: `autoscaling_groups_elb_check`
- ✅ `cloudtrail.1`: `logs_encrypted`
- ✅ `cloudtrail.2`: `cloudtrail_enabled_all_regions`
- ✅ `cloudtrail.3`: `log_file_validation_enabled`
- ✅ `cloudtrail.4`: `integrated_with_cloudwatch_logs`
- ✅ `codebuild.1`: `check_oauth_usage_for_sources`
- ✅ `codebuild.2`: `check_environment_variables`
- ✅ `config.1`: `config_enabled_all_regions`
<!-- AUTO-GENERATED-INCLUDED-CHECKS-END -->


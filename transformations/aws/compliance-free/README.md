# CloudQuery &times; dbt: AWS Compliance Package

## Overview

### Requirements

- [dbt](https://docs.getdbt.com/docs/installation)
- [CloudQuery](https://www.cloudquery.io/docs/quickstart)

One of the below databases

- [PostgreSQL](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql)
- [Snowflake](https://hub.cloudquery.io/plugins/destination/cloudquery/snowflake)

### What's in the pack

The pack contains the free version.

#### Running Your dbt Project

Navigate to your dbt project directory, where your `dbt_project.yml` resides.

If everything compiles without errors, you can then execute:

```bash
dbt run
```

This command will run all your `dbt` models and create tables/views in your destination database as defined in your models.

To run specific models and the models in the dependency graph, the following `dbt run` commands can be used:

To select a specific model and the dependencies in the dependency graph:

```bash
dbt run --select +<model_name>
```

For a specific model and the dependencies in the dependency graph:

```bash
dbt run --models +<model_name>
```

#### Models

- **aws_compliance\_\_cis_v1.2.0**: AWS CIS V1.2.0 benchmarks, available for PostgreSQL
- **aws_compliance_pci_dss_v3.2.1**: AWS PCI DSS V3.2.1 benchmark.
- **aws_compliance\_\_foundational_security**: AWS Foundational Security benchmark, available only for Snowflake

The free version contains 10% of the full pack's checks.

<!-- AUTO-GENERATED-INCLUDED-CHECKS-START -->
#### Included Checks

##### `cis_v1.2.0`

- ✅ `1.1`: `avoid_root_usage`
- ✅ `1.2`: `mfa_enabled_for_console_access`
- ✅ `1.3`: `unused_creds_disabled`
- ✅ `1.4`: `old_access_keys`
- ✅ `1.5`: `password_policy_min_uppercase`
- ✅ `1.6`: `password_policy_min_lowercase`

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

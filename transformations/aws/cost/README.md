# CloudQuery &times; dbt: AWS Cost Package

## Overview

### Requirements

- [dbt](https://docs.getdbt.com/docs/installation)
- [PostgreSQL](https://www.postgresql.org/download/) or any other mutually supported destination
- [CloudQuery](https://www.cloudquery.io/docs/quickstart) with [GCP](https://www.cloudquery.io/docs/plugins/sources/gcp/overview) and [PostgreSQL](https://www.cloudquery.io/docs/plugins/destinations/postgresql/overview)

[Quick guide](https://www.cloudquery.io/integrations/gcp/postgresql) for GCP-Postgres integration.

#### dbt Installation

An example of how to install dbt to work with Postgres.

First, install `dbt`:

```bash
pip install dbt-postgres
```

Create the profile directory:

```bash
mkdir -p ~/.dbt
```

Create a `profiles.yml` file in your profile directory (e.g. `~/.dbt/profiles.yml`):

```yaml
gcp_compliance: # This should match the name in your dbt_project.yml
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

#### Running Your dbt Project

Navigate to your dbt project directory, where your `dbt_project.yml` resides.

Before executing the `dbt run` command, it might be useful to check for any potential issues:

```bash
dbt compile --vars '{"cost_usage_table": "<cost_and_usage_report>"}'
```

If everything compiles without errors, you can then execute:

```bash
dbt run --vars '{"cost_usage_table": "<cost_and_usage_report>"}'
```

This command will run your `dbt` models and create tables/views in your PostgreSQL database as defined in your models.

### Usage

### CloudQuery Sync

Make sure you synced your AWS metadata with CloudQuery [AWS source plugin](https://www.cloudquery.io/docs/plugins/sources/overview), Cost and Usage data with the [file plugin](https://github.com/cloudquery/plugins-premium/tree/main/plugins/file), and [PostgreSQL destination](https://www.cloudquery.io/docs/plugins/destinations/postgresql/overview).

A configuration to sync both AWS metadata and Cost and Usage data with PostgreSQL destination should look like this:

```yaml
kind: source
spec:
  name: file
  version: v1.0.0
  destinations: [postgresql]
  # path: cloudquery/file
  path: localhost:7777
  registry: grpc
  tables: ["*"]
  spec:
    files_dir: "<path-to-your-aws-cost-and-usage-reports>"
---
kind: source
spec:
  name: aws
  version: v22.1.0
  destinations: [postgresql]
  path: cloudquery/aws
  tables: ["*"]
  skip_tables:
    - aws_ec2_vpc_endpoint_services
    - aws_cloudtrail_events
    - aws_docdb_cluster_parameter_groups
    - aws_docdb_engine_versions
    - aws_ec2_instance_types
    - aws_elasticache_engine_versions
    - aws_elasticache_parameter_groups
    - aws_elasticache_reserved_cache_nodes_offerings
    - aws_elasticache_service_updates
    - aws_iam_group_last_accessed_details
    - aws_iam_policy_last_accessed_details
    - aws_iam_role_last_accessed_details
    - aws_iam_user_last_accessed_details
    - aws_neptune_cluster_parameter_groups
    - aws_neptune_db_parameter_groups
    - aws_rds_cluster_parameter_groups
    - aws_rds_db_parameter_groups
    - aws_rds_engine_versions
    - aws_servicequotas_services
---
kind: destination
spec:
  name: postgresql
  path: cloudquery/postgresql
  version: "v5.0.2"
  spec:
    connection_string: postgresql://postgres:pass@localhost:5432/postgres
```

- Run dbt: `dbt run --vars '{"cost_usage_table": "<cost_and_usage_report>"}'`

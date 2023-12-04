# CloudQuery &times; dbt: AWS Compliance Package

## Overview

### Requirements

- [dbt](https://docs.getdbt.com/docs/installation)
- [CloudQuery](https://www.cloudquery.io/docs/quickstart)

One of the below databases

- [PostgreSQL](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql)
- [Snowflake](https://hub.cloudquery.io/plugins/destination/cloudquery/snowflake)
- [BigQuery](https://hub.cloudquery.io/plugins/destination/cloudquery/bigquery)

### What's in the pack

The pack contains the premium version.

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

The premium version contains all checks.

<!-- AUTO-GENERATED-INCLUDED-CHECKS-START -->
<!-- AUTO-GENERATED-INCLUDED-CHECKS-END -->

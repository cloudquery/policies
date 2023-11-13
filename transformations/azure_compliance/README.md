# CloudQuery k8s Compliance Package

## Overview

This package contains dbt models (views) that gives compliance insights from CloudQuery [Azure plugin](https://hub.cloudquery.io/plugins/source/cloudquery/azure) data.

### Requirements

- [CloudQuery](https://www.cloudquery.io/docs/quickstart)
- [CloudQuery Azure plugin](https://hub.cloudquery.io/plugins/source/cloudquery/azure)
- [dbt](https://docs.getdbt.com/docs/installation)

One of the below databases
- [PostgreSQL](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql/v6.1.3/docs)
- [Snowflake](https://hub.cloudquery.io/plugins/destination/cloudquery/snowflake/v3.3.3/docs)

### What's in the pack

The pack contains a free version and a full (paid) version.

#### Models

- **azure_compliance__cis_v1_3_0.sql**: Azure Compliance CIS V1.3.0, available for PostgreSQL.
- **azure_compliance_hipaa_hitrust_v9_2.sql**: Azure Compliance HIPPA HITRUST V9.2, available for PostgreSQL.

The free version contains 10% of the full pack's queries.
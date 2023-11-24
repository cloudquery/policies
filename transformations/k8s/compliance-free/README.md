# CloudQuery k8s Compliance Package

## Overview

This package contains dbt models (views) that gives compliance insights from CloudQuery [k8s plugins](https://hub.cloudquery.io/plugins/source/cloudquery/k8s) data.

### Requirements

- [CloudQuery](https://www.cloudquery.io/docs/quickstart)
- [CloudQuery k8s plugin](https://hub.cloudquery.io/plugins/source/cloudquery/k8s)
- [dbt](https://docs.getdbt.com/docs/installation)

One of the below databases

- [PostgreSQL](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql/v6.1.3/docs)
- [Snowflake](https://hub.cloudquery.io/plugins/destination/cloudquery/snowflake/v3.3.3/docs)

### What's in the pack

The pack contains the free version.

#### Models

- **k8s_compliance\_\_cis_v1_7.sql**: Kubernetes CIS V1.7 benchmarks, available for PostgreSQL.
- **k8s_compliance\_\_nsa_cisa_v1.sql**: Kubernetes NSA/CISA V1 benchmarks, available for PostgreSQL.

The free version contains 10% of the full pack's queries.

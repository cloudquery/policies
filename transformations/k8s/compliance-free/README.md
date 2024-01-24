# CloudQuery k8s Compliance Package

## Overview

This package contains dbt models (views) that gives compliance insights from CloudQuery [k8s plugins](https://hub.cloudquery.io/plugins/source/cloudquery/k8s) data.

### Requirements

- [CloudQuery](https://www.cloudquery.io/docs/quickstart)
- [CloudQuery k8s plugin](https://hub.cloudquery.io/plugins/source/cloudquery/k8s)
- [dbt](https://docs.getdbt.com/docs/installation)

One of the below databases

- [PostgreSQL](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql)
- [Snowflake](https://hub.cloudquery.io/plugins/destination/cloudquery/snowflake)

### What's in the pack

The pack contains the free version.

#### Models

- **k8s_compliance\_\_cis_v1_7.sql**: Kubernetes CIS V1.7 benchmarks, available for PostgreSQL.
- **k8s_compliance\_\_nsa_cisa_v1.sql**: Kubernetes NSA/CISA V1 benchmarks, available for PostgreSQL.

The free version contains 10% of the full pack's queries.

<!-- AUTO-GENERATED-INCLUDED-CHECKS-START -->
#### Included Checks

##### `Kubernetes CIS v1.7.0`

- ✅ `api_server_1_2_1`: `api_server_1_2_1`
- ✅ `api_server_1_2_2`: `api_server_1_2_2`
- ✅ `api_server_1_2_3`: `api_server_1_2_3`
- ✅ `api_server_1_2_4`: `api_server_1_2_4`
- ✅ `api_server_1_2_5`: `api_server_1_2_5`
- ✅ `api_server_1_2_6`: `api_server_1_2_6`
- ✅ `api_server_1_2_7`: `api_server_1_2_7`
- ✅ `api_server_1_2_8`: `api_server_1_2_8`
- ✅ `api_server_1_2_1`: `api_server_1_2_1`

##### `nsa_cisa_v1`

- ✅ `daemonset_cpu_limit`: `daemonset_cpu_limit`
- ✅ `deployment_cpu_limit`: `deployment_cpu_limit`
- ✅ `job_cpu_limit`: `job_cpu_limit`
- ✅ `namespace_limit_range_default_cpu_limit`: `namespace_limit_range_default_cpu_limit`
- ✅ `namespace_resource_quota_cpu_limit`: `namespace_resource_quota_cpu_limit`
- ✅ `replicaset_cpu_limit`: `replicaset_cpu_limit`

##### `Kubernetes CIS v1.8.0`

- ✅ `api_server_1_2_1`: `api_server_1_2_1`
- ✅ `api_server_1_2_2`: `api_server_1_2_2`
- ✅ `api_server_1_2_3`: `api_server_1_2_3`
- ✅ `api_server_1_2_4`: `api_server_1_2_4`
- ✅ `api_server_1_2_5`: `api_server_1_2_5`
- ✅ `api_server_1_2_6`: `api_server_1_2_6`
- ✅ `api_server_1_2_7`: `api_server_1_2_7`
- ✅ `api_server_1_2_8`: `api_server_1_2_8`
<!-- AUTO-GENERATED-INCLUDED-CHECKS-END -->
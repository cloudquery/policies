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

The pack contains the premium version.

#### Models

- **k8s_compliance\_\_cis_v1_7.sql**: Kubernetes CIS V1.7 benchmarks, available for PostgreSQL.
- **k8s_compliance\_\_nsa_cisa_v1.sql**: Kubernetes NSA/CISA V1 benchmarks, available for PostgreSQL.

The premium version contains all queries.

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
- ✅ `api_server_1_2_9`: `api_server_1_2_9`
- ✅ `api_server_1_2_10`: `api_server_1_2_10`
- ✅ `api_server_1_2_11`: `api_server_1_2_11`
- ✅ `api_server_1_2_12`: `api_server_1_2_12`
- ✅ `api_server_1_2_13`: `api_server_1_2_13`
- ✅ `api_server_1_2_14`: `api_server_1_2_14`
- ✅ `api_server_1_2_15`: `api_server_1_2_15`
- ✅ `api_server_1_2_16`: `api_server_1_2_16`
- ✅ `api_server_1_2_17`: `api_server_1_2_17`
- ✅ `api_server_1_2_18`: `api_server_1_2_18`
- ✅ `api_server_1_2_19`: `api_server_1_2_19`
- ✅ `api_server_1_2_20`: `api_server_1_2_20`
- ✅ `api_server_1_2_21`: `api_server_1_2_21`
- ✅ `api_server_1_2_22`: `api_server_1_2_22`
- ✅ `api_server_1_2_23`: `api_server_1_2_23`
- ✅ `api_server_1_2_24`: `api_server_1_2_24`
- ✅ `api_server_1_2_25`: `api_server_1_2_25`
- ✅ `api_server_1_2_26`: `api_server_1_2_26`
- ✅ `api_server_1_2_27`: `api_server_1_2_27`
- ✅ `api_server_1_2_28`: `api_server_1_2_28`
- ✅ `api_server_1_2_29`: `api_server_1_2_29`
- ✅ `api_server_1_2_30`: `api_server_1_2_30`
- ✅ `api_server_1_2_31`: `api_server_1_2_31`
- ✅ `controller_manager_1_3_1`: `controller_manager_1_3_1`
- ✅ `controller_manager_1_3_2`: `controller_manager_1_3_2`
- ✅ `controller_manager_1_3_3`: `controller_manager_1_3_3`
- ✅ `controller_manager_1_3_4`: `controller_manager_1_3_4`
- ✅ `controller_manager_1_3_5`: `controller_manager_1_3_5`
- ✅ `controller_manager_1_3_6`: `controller_manager_1_3_6`
- ✅ `controller_manager_1_3_7`: `controller_manager_1_3_7`
- ✅ `etcd_2_1`: `etcd_2_1`
- ✅ `etcd_2_2`: `etcd_2_2`
- ✅ `etcd_2_3`: `etcd_2_3`
- ✅ `etcd_2_4`: `etcd_2_4`
- ✅ `etcd_2_5`: `etcd_2_5`
- ✅ `etcd_2_6`: `etcd_2_6`
- ✅ `logging_3_2_1`: `logging_3_2_1`
- ✅ `pod_security_standards_5_2_2`: `pod_security_standards_5_2_2`
- ✅ `pod_security_standards_5_2_3`: `pod_security_standards_5_2_3`
- ✅ `pod_security_standards_5_2_4`: `pod_security_standards_5_2_4`
- ✅ `pod_security_standards_5_2_5`: `pod_security_standards_5_2_5`
- ✅ `pod_security_standards_5_2_6`: `pod_security_standards_5_2_6`
- ✅ `pod_security_standards_5_2_8`: `pod_security_standards_5_2_8`
- ✅ `pod_security_standards_5_2_9`: `pod_security_standards_5_2_9`
- ✅ `pod_security_standards_5_2_10`: `pod_security_standards_5_2_10`
- ✅ `pod_security_standards_5_2_11`: `pod_security_standards_5_2_11`
- ✅ `pod_security_standards_5_2_12`: `pod_security_standards_5_2_12`
- ✅ `pod_security_standards_5_2_13`: `pod_security_standards_5_2_13`
- ✅ `pod_security_standards_5_3_2`: `pod_security_standards_5_3_2`
- ✅ `pod_security_standards_5_4_1`: `pod_security_standards_5_4_1`
- ✅ `pod_security_standards_5_4_2`: `pod_security_standards_5_4_2`
- ✅ `pod_security_standards_5_7_2`: `pod_security_standards_5_7_2`
- ✅ `pod_security_standards_5_7_3`: `pod_security_standards_5_7_3`
- ✅ `pod_security_standards_5_7_4`: `pod_security_standards_5_7_4`
- ✅ `rbac_and_service_accounts_5_1_1`: `rbac_and_service_accounts_5_1_1`
- ✅ `rbac_and_service_accounts_5_1_2`: `rbac_and_service_accounts_5_1_2`
- ✅ `rbac_and_service_accounts_5_1_3`: `rbac_and_service_accounts_5_1_3`
- ✅ `rbac_and_service_accounts_5_1_4`: `rbac_and_service_accounts_5_1_4`
- ✅ `rbac_and_service_accounts_5_1_5`: `rbac_and_service_accounts_5_1_5`
- ✅ `rbac_and_service_accounts_5_1_6`: `rbac_and_service_accounts_5_1_6`
- ✅ `rbac_and_service_accounts_5_1_7`: `rbac_and_service_accounts_5_1_7`
- ✅ `rbac_and_service_accounts_5_1_8`: `rbac_and_service_accounts_5_1_8`
- ✅ `rbac_and_service_accounts_5_1_9`: `rbac_and_service_accounts_5_1_9`
- ✅ `rbac_and_service_accounts_5_1_10`: `rbac_and_service_accounts_5_1_10`
- ✅ `rbac_and_service_accounts_5_1_11`: `rbac_and_service_accounts_5_1_11`
- ✅ `rbac_and_service_accounts_5_1_12`: `rbac_and_service_accounts_5_1_12`
- ✅ `rbac_and_service_accounts_5_1_13`: `rbac_and_service_accounts_5_1_13`
- ✅ `scheduler_1_4_1`: `scheduler_1_4_1`
- ✅ `scheduler_1_4_2`: `scheduler_1_4_2`
- ✅ `api_server_1_2_1`: `api_server_1_2_1`
<!-- AUTO-GENERATED-INCLUDED-CHECKS-END -->
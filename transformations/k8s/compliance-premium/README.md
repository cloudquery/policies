# CloudQuery k8s Compliance Package

## Overview

Welcome to K8S Compliance Package, a compliance solution that works on top of the CloudQuery framework. This package offers automated checks across various K8S services, following benchmarks such as CIS and CISA NSA.
Using this solution you can get instant insights about your security posture and make sure you are following the recommended security guidelines defined by CIS, CISA NSA and more.


### Examples
How many checks failed in the CIS 1.8 benchmark? (PostgreSQL)
```sql
SELECT count(*) as failed_count
FROM k8s_compliance__cis_v1_8
WHERE status = 'fail'
```

Which resource failed the most tests in the CISA NSA benchmark? (PostgreSQL)
```sql
SELECT resource_id, count(*) as failed_count
FROM k8s_compliance__nsa_cisa_v1
WHERE status = 'fail'
GROUP BY resource_id
ORDER BY count(*) DESC
```

### Requirements

- [dbt](https://docs.getdbt.com/docs/core/pip-install)
- [CloudQuery](https://www.cloudquery.io/docs/quickstart)
- [A CloudQuery Account](https://www.cloudquery.io/auth/register)
- [K8S Source Plugin](https://hub.cloudquery.io/plugins/source/cloudquery/k8s/latest/docs)

One of the below databases

- [PostgreSQL](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql)
- [Snowflake](https://hub.cloudquery.io/plugins/destination/cloudquery/snowflake)
- [BigQuery](https://hub.cloudquery.io/plugins/destination/cloudquery/bigquery)

### What's in the pack

This package includes: Automated compliance checks following CIS and CISA NSA.

## To run this package you need to complete the following steps

### Setting up the DBT profile (PostgreSQL)
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
k8s_compliance: # This should match the name in your dbt_project.yml
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
`cloudquery login` in your terminal.

### Syncing K8S data
Based on the models you are interested in running, you need to sync the relevant tables.
this is an example sync for the relevant tables for all the models (views) in the policy and with the PostgreSQL destination. This package also supports Snowflake and Google BigQuery

```yml
kind: source
spec:
  name: k8s # The source type, in this case, K8S.
  path: cloudquery/k8s # The plugin path for handling K8S sources.
  registry: cloudquery # The registry from which the K8S plugin is sourced.
  version: "6.0.9" # The version of the K8S plugin.
  tables: ["k8s_networking_network_policies","k8s_rbac_roles","k8s_rbac_cluster_roles","k8s_core_resource_quotas","k8s_core_limit_ranges","k8s_core_namespaces","k8s_core_service_accounts","k8s_rbac_cluster_role_bindings","k8s_apps_daemon_sets","k8s_batch_jobs","k8s_apps_replica_sets","k8s_core_pods","k8s_apps_deployments",]
  destinations: ["postgresql"] # The destination for the data, in this case, PostgreSQL.
  skip_dependent_tables: true
  spec:

---
kind: destination
spec:
  name: "postgresql" # The type of destination, in this case, PostgreSQL.
  path: "cloudquery/postgresql" # The plugin path for handling PostgreSQL as a destination.
  registry: "cloudquery" # The registry from which the PostgreSQL plugin is sourced.
  version: "v8.0.1" # The version of the PostgreSQL plugin.

  spec:
    connection_string: "${POSTGRESQL_CONNECTION_STRING}"  # set the environment variable in a format like 
    # postgresql://postgres:pass@localhost:5432/postgres?sslmode=disable
    # You can also specify the connection string in DSN format, which allows for special characters in the password:
    # connection_string: "user=postgres password=pass+0-[word host=localhost port=5432 dbname=postgres"

 ```

 See [Hub](https://hub.cloudquery.io) to browse individual plugins and to get their detailed documentation.

## Pre-Run Table Existence Check in Your dbt Project

Before executing models in your dbt project, it's a good practice to ensure that all necessary tables are available in your database. This step prevents failures during model execution due to missing tables. 

### Run the Table Check Operation

To verify the existence of required tables for specific models, use the `run-operation` command provided by dbt. This command invokes a custom operation (macro) that checks for the presence of necessary tables in the database.

**Command to Check Table Existence**:
```bash
dbt run-operation check_tables_exist --args '{"variable_name": "variable_name_here"}'
```

### Variable Names You Can Use
Each variable name corresponds to a specific model or a set of models within your dbt project. Use one of the following variable names as needed:

- **cis_v1_8**
- **nsa_cisa_v1**
- **k8s_models**

### Running Your dbt Project

Navigate to your dbt project directory, where your `dbt_project.yml` resides. Make sure to have an existing profile in your `profiles.yml` that contains your PostgreSQL/Snowflake/BigQuery connection and authentication information.

If everything compiles without errors, you can then execute:

```bash
dbt run
```

This command will run all your `dbt` models and create tables/views in your destination database as defined in your models.

**Note:** If running locally, ensure you are using `dbt-core` and not `dbt-cloud-cli` as dbt-core does not require extra authentication.

## Running Specific Models in dbt

To execute a specific model along with its dependencies in your dbt project, use the `--select` option with the `dbt run` command. This command ensures that all dependencies for the specified model are also executed.

```bash
dbt run --select +<model_name>
```

#### Models

- **k8s_compliance\_\_cis_v1_8.sql**: Kubernetes CIS V1.7 benchmarks, available for PostgreSQL, Snowflake and Google BigQuery.
- **k8s_compliance\_\_nsa_cisa_v1.sql**: Kubernetes NSA/CISA V1 benchmarks, available for PostgreSQL.

All of the models contain the following columns:
- **framework**: The benchmark the check belongs to.
- **check_id**: The check identifier (either a number or the service name and numberr).
- **title**: The name/title of the check.
- **context**: The K8S context.
- **resource_id**: The resource id.
- **resource_name**: The resource name.
- **status**: The status of the check (fail / pass).

#### Tables
- **k8s_compliance\_\_cis_v1_8.sql**:
```yaml
"k8s_networking_network_policies",
"k8s_rbac_cluster_role_bindings",
"k8s_core_pods",
"k8s_rbac_cluster_roles",
"k8s_core_namespaces",
"k8s_core_service_accounts",
"k8s_rbac_roles"
```
- **k8s_compliance\_\_nsa_cisa_v1.sql**:
```yaml
"k8s_networking_network_policies",
"k8s_core_pods",
"k8s_core_namespaces",
"k8s_core_service_accounts",
"k8s_apps_daemon_sets",
"k8s_apps_replica_sets",
"k8s_apps_deployments",
"k8s_core_resource_quotas",
"k8s_core_limit_ranges",
"k8s_batch_jobs"
```

<!-- AUTO-GENERATED-INCLUDED-CHECKS-START -->
#### Included Checks

##### `Kubernetes CIS v1.8.0`

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
- ✅ `pod_security_standards_5_2_1`: `pod_security_standards_5_2_1`
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

##### `Kubernetes CIS v1.7.0`

- ✅ `api_server_1_2_1`: `api_server_1_2_1`

##### `nsa_cisa_v1`

- ✅ `container_disallow_host_path`: `pod_volume_host_path`
- ✅ `daemonset_container_privilege_disabled`: `daemonset_container_privilege_disabled`
- ✅ `daemonset_container_privilege_escalation_disabled`: `daemonset_container_privilege_escalation_disabled`
- ✅ `daemonset_cpu_limit`: `daemonset_cpu_limit`
- ✅ `daemonset_cpu_request`: `daemonset_cpu_request`
- ✅ `daemonset_host_network_access_disabled`: `daemonset_host_network_access_disabled`
- ✅ `daemonset_hostpid_hostipc_sharing_disabled`: `daemonset_hostpid_hostipc_sharing_disabled`
- ✅ `daemonset_immutable_container_filesystem`: `daemonset_immutable_container_filesystem`
- ✅ `daemonset_memory_limit`: `daemonset_memory_limit`
- ✅ `daemonset_memory_request`: `daemonset_memory_request`
- ✅ `daemonset_non_root_container`: `daemonset_non_root_container`
- ✅ `deployment_container_privilege_disabled`: `deployment_container_privilege_disabled`
- ✅ `deployment_container_privilege_escalation_disabled`: `deployment_container_privilege_escalation_disabled`
- ✅ `deployment_cpu_limit`: `deployment_cpu_limit`
- ✅ `deployment_cpu_request`: `deployment_cpu_request`
- ✅ `deployment_host_network_access_disabled`: `deployment_host_network_access_disabled`
- ✅ `deployment_hostpid_hostipc_sharing_disabled`: `deployment_hostpid_hostipc_sharing_disabled`
- ✅ `deployment_immutable_container_filesystem`: `deployment_immutable_container_filesystem`
- ✅ `deployment_memory_limit`: `deployment_memory_limit`
- ✅ `deployment_memory_request`: `deployment_memory_request`
- ✅ `deployment_non_root_container`: `deployment_non_root_container`
- ✅ `job_container_privilege_disabled`: `job_container_privilege_disabled`
- ✅ `job_container_privilege_escalation_disabled`: `job_container_privilege_escalation_disabled`
- ✅ `job_cpu_limit`: `job_cpu_limit`
- ✅ `job_host_network_access_disabled`: `job_host_network_access_disabled`
- ✅ `job_hostpid_hostipc_sharing_disabled`: `job_hostpid_hostipc_sharing_disabled`
- ✅ `job_immutable_container_filesystem`: `job_immutable_container_filesystem`
- ✅ `job_memory_limit`: `job_memory_limit`
- ✅ `job_memory_request`: `job_memory_request`
- ✅ `job_non_root_container`: `job_non_root_container`
- ✅ `namespace_limit_range_default_cpu_limit`: `namespace_limit_range_default_cpu_limit`
- ✅ `namespace_limit_range_default_cpu_request`: `namespace_limit_range_default_cpu_request`
- ✅ `namespace_limit_range_default_memory_limit`: `namespace_limit_range_default_memory_limit`
- ✅ `namespace_limit_range_default_memory_request`: `namespace_limit_range_default_memory_request`
- ✅ `namespace_resource_quota_cpu_limit`: `namespace_resource_quota_cpu_limit`
- ✅ `namespace_resource_quota_cpu_request`: `namespace_resource_quota_cpu_request`
- ✅ `namespace_resource_quota_memory_limit`: `namespace_resource_quota_memory_limit`
- ✅ `namespace_resource_quota_memory_request`: `namespace_resource_quota_memory_request`
- ✅ `network_policy_default_deny_egress`: `network_policy_default_deny_egress`
- ✅ `network_policy_default_deny_ingress`: `network_policy_default_deny_ingress`
- ✅ `pod_container_privilege_disabled`: `pod_container_privilege_disabled`
- ✅ `pod_container_privilege_escalation_disabled`: `pod_host_network_access_disabled`
- ✅ `pod_hostpid_hostipc_sharing_disabled`: `pod_hostpid_hostipc_sharing_disabled`
- ✅ `pod_immutable_container_filesystem`: `pod_immutable_container_filesystem`
- ✅ `pod_non_root_container`: `pod_non_root_container`
- ✅ `pod_service_account_token_disabled`: `pod_service_account_token_disabled`
- ✅ `replicaset_container_privilege_disabled`: `replicaset_container_privilege_disabled`
- ✅ `replicaset_container_privilege_escalation_disabled`: `replicaset_host_network_access_disabled`
- ✅ `replicaset_cpu_limit`: `replicaset_cpu_limit`
- ✅ `replicaset_cpu_request`: `replicaset_cpu_request`
- ✅ `replicaset_hostpid_hostipc_sharing_disabled`: `replicaset_hostpid_hostipc_sharing_disabled`
- ✅ `replicaset_immutable_container_filesystem`: `replicaset_immutable_container_filesystem`
- ✅ `replicaset_memory_limit`: `replicaset_memory_limit`
- ✅ `replicaset_memory_request`: `replicaset_memory_request`
- ✅ `replicaset_non_root_container`: `replicaset_non_root_container`
- ✅ `service_account_token_disabled`: `service_account_token_disabled`
<!-- AUTO-GENERATED-INCLUDED-CHECKS-END -->


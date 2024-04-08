# CloudQuery k8s Compliance Package (Free)


## Overview
Welcome to our free edition of the [K8S Compliance Package](https://hub.cloudquery.io/addons/transformation/cloudquery/k8s-compliance-premium/latest/docs), a free compliance solution that works on top of the CloudQuery framework. This package offers automated checks across various K8S services, following benchmarks such as CIS and K8S foundational security standards.
Using this solution you can get instant insights about your security posture and make sure you are following the recommended security guidelines defined by K8S, CIS and more.

This package is a free version of the more comprehensive [K8S Compliance Package](https://hub.cloudquery.io/addons/transformation/cloudquery/k8s-compliance-premium/latest/docs)


### Examples

How many checks failed in the CIS 1.7.0 benchmark? (PostgreSQL)
```sql
SELECT count(*) as failed_count
FROM k8s_compliance__cis_v1_7_free
WHERE status = 'fail'
```

### Requirements

- [dbt](https://docs.getdbt.com/docs/installation)
- [CloudQuery](https://www.cloudquery.io/docs/quickstart)
- [A CloudQuery Account](https://www.cloudquery.io/auth/register)
- [K8S Source Plugin](https://hub.cloudquery.io/plugins/source/cloudquery/k8s/latest/docs)

One of the below databases

- [PostgreSQL](https://hub.cloudquery.io/plugins/destination/cloudquery/postgresql)
- [Snowflake](https://hub.cloudquery.io/plugins/destination/cloudquery/snowflake)
- [BigQuery](https://hub.cloudquery.io/plugins/destination/cloudquery/bigquery)

### What's in the pack

The pack contains the free version of the compliance package which includes some of the checks from the K8S Foundational Security benchmark, CIS 1.2.0 benchmark and more.

## To run this package you need to complete the following steps

### Setting up the DBT profile (PostgreSQL)
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
  tables: ["k8s_core_resource_quotas","k8s_core_limit_ranges","k8s_core_namespaces","k8s_apps_daemon_sets","k8s_batch_jobs","k8s_apps_replica_sets","k8s_core_pods","k8s_apps_deployments"]
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

#### Running Your dbt Project

Navigate to your dbt project directory, where your `dbt_project.yml` resides. Make sure to have an existing profile in your `profiles.yml` that contains your PostgreSQL/Snowflake/BigQuery connection and authentication information.

If everything compiles without errors, you can then execute:

```bash
dbt run
```

This command will run all your `dbt` models and create tables/views in your destination database as defined in your models.

**Note:** If running locally, ensure you are using `dbt-core` and not `dbt-cloud-cli` as dbt-core does not require extra authentication.

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
The free version contains 10% of the full pack's checks.
The following models are available for PostgreSQL, Snowflake and Google BigQuery.
- **k8s_compliance\_\_cis_v1_7.sql**: Kubernetes CIS V1.7.
- **k8s_compliance\_\_cis_v1_8.sql**: Kubernetes CIS V1.8.

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
- **k8s_compliance\_\_cis_v1_7.sql**: 
```yaml
"k8s_core_pods"
```
- **k8s_compliance\_\_cis_v1_8.sql**:
```yaml
"k8s_core_pods"
```
- **k8s_compliance\_\_nsa_cisa_v1.sql**:
```yaml
"k8s_core_pods",
"k8s_core_namespaces",
"k8s_apps_daemon_sets",
"k8s_apps_replica_sets",
"k8s_apps_deployments",
"k8s_core_resource_quotas",
"k8s_core_limit_ranges",
"k8s_batch_jobs"
```

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
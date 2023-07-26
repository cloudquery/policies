# AWS Cost and Usage reports views with PostgreSQL

## Requirements

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

### Run the policy

- Install Python >= 3.9
- Run `pip install -r requirements.txt`
- Run `cp env.example` to `.env` and fill the PostgreSQL environment credentials
- Run `python main.py`

#### VirtualEnv

- Run `pip install virtualenv`
- Run `virtualenv venv`
- Run `source venv/bin/activate`
- Follow the steps above. This way you will have a virtual environment for dependencies. `deactivate` to exit the virtual environment.
- Alternatively, you can use the `pip` and `python` binaries from the virtual environment (inside `venv/bin/`) directly.

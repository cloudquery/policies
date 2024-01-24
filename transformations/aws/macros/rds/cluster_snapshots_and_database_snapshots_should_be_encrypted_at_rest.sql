{% macro cluster_snapshots_and_database_snapshots_should_be_encrypted_at_rest(framework, check_id) %}
  {{ return(adapter.dispatch('cluster_snapshots_and_database_snapshots_should_be_encrypted_at_rest')(framework, check_id)) }}
{% endmacro %}

{% macro default__cluster_snapshots_and_database_snapshots_should_be_encrypted_at_rest(framework, check_id) %}{% endmacro %}

{% macro postgres__cluster_snapshots_and_database_snapshots_should_be_encrypted_at_rest(framework, check_id) %}
(
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS cluster snapshots and database snapshots should be encrypted at rest' as title,
    account_id,
    arn AS resource_id,
    case when storage_encrypted != TRUE then 'fail' else 'pass' end as status
from aws_rds_cluster_snapshots
)
union
(
    select
        '{{framework}}' As framework,
        '{{check_id}}' As check_id,
        'RDS cluster snapshots and database snapshots should be encrypted at rest' as title,
        account_id,
        arn AS resource_id,
        case when encrypted != TRUE then 'fail' else 'pass' end as status
    from aws_rds_db_snapshots
)
{% endmacro %}

{% macro snowflake__cluster_snapshots_and_database_snapshots_should_be_encrypted_at_rest(framework, check_id) %}
(
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS cluster snapshots and database snapshots should be encrypted at rest' as title,
    account_id,
    arn AS resource_id,
    case when storage_encrypted != TRUE then 'fail' else 'pass' end as status
from aws_rds_cluster_snapshots
)
union
(
    select
        '{{framework}}' As framework,
        '{{check_id}}' As check_id,
        'RDS cluster snapshots and database snapshots should be encrypted at rest' as title,
        account_id,
        arn AS resource_id,
        case when encrypted != TRUE then 'fail' else 'pass' end as status
    from aws_rds_db_snapshots
)
{% endmacro %}

{% macro bigquery__cluster_snapshots_and_database_snapshots_should_be_encrypted_at_rest(framework, check_id) %}
(
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS cluster snapshots and database snapshots should be encrypted at rest' as title,
    account_id,
    arn AS resource_id,
    case when storage_encrypted != TRUE then 'fail' else 'pass' end as status
from {{ full_table_name("aws_rds_cluster_snapshots") }}
)
union all
(
    select
        '{{framework}}' As framework,
        '{{check_id}}' As check_id,
        'RDS cluster snapshots and database snapshots should be encrypted at rest' as title,
        account_id,
        arn AS resource_id,
        case when encrypted != TRUE then 'fail' else 'pass' end as status
    from {{ full_table_name("aws_rds_db_snapshots") }}
)
{% endmacro %}
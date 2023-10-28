{% macro rds_cluster_snapshots_and_database_snapshots_should_be_encrypted_at_rest(framework, check_id) %}
  {{ return(adapter.dispatch('rds_cluster_snapshots_and_database_snapshots_should_be_encrypted_at_rest')(framework, check_id)) }}
{% endmacro %}

{% macro default__rds_cluster_snapshots_and_database_snapshots_should_be_encrypted_at_rest(framework, check_id) %}{% endmacro %}

{% macro postgres__rds_cluster_snapshots_and_database_snapshots_should_be_encrypted_at_rest(framework, check_id) %}
(
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'RDS cluster snapshots and database snapshots should be encrypted at rest' as title,
    account_id,
    arn AS resource_id,
    case when storage_encrypted is not TRUE then 'fail' else 'pass' end as status
from aws_rds_cluster_snapshots
)
union
(
    select
        '{{framework}}' as framework,
        '{{check_id}}' as check_id,
        'RDS cluster snapshots and database snapshots should be encrypted at rest' as title,
        account_id,
        arn AS resource_id,
        case when encrypted is not TRUE then 'fail' else 'pass' end as status
    from aws_rds_db_snapshots
)
{% endmacro %}

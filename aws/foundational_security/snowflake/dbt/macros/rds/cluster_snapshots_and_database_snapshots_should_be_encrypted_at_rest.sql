{% macro cluster_snapshots_and_database_snapshots_should_be_encrypted_at_rest(framework, check_id) %}
insert into aws_policy_results
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
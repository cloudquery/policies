{% macro point_in_time_recovery(framework, check_id) %}
insert into aws_policy_results
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'DynamoDB tables should have point-in-time recovery enabled' as title,
    t.account_id,
    t.arn as resource_id,
  case when
    b.point_in_time_recovery_description:PointInTimeRecoveryStatus is distinct from 'ENABLED'
    then 'fail'
    else 'pass'
  end as status
FROM aws_dynamodb_tables t
  LEFT JOIN aws_dynamodb_table_continuous_backups b ON b.table_arn = t.arn
{% endmacro %}
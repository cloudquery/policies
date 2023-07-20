
AUTOSCALE_OR_ONDEMAND = """
INSERT INTO aws_policy_results
SELECT
    %s as execution_time,
    %s as framework,
    %s as check_id,
    'DynamoDB tables should automatically scale capacity with demand' as title,
    t.account_id,
    pr.arn as resource_id,
  CASE WHEN
    t.billing_mode_summary:BillingMode IS DISTINCT FROM 'PAY_PER_REQUEST'
    AND (
        (s.replica_provisioned_read_capacity_auto_scaling_settings:AutoScalingDisabled::BOOLEAN IS DISTINCT FROM FALSE)
        OR (s.replica_provisioned_write_capacity_auto_scaling_settings:AutoScalingDisabled::BOOLEAN IS DISTINCT FROM FALSE)
    )
    AND (pr._cq_id IS NULL OR pw._cq_id IS NULL)
    then 'fail'
    else 'pass'
  end as status
FROM aws_dynamodb_tables t
    LEFT JOIN aws_dynamodb_table_replica_auto_scalings s ON s.table_arn = t.arn
    LEFT JOIN aws_applicationautoscaling_policies pr ON (pr.service_namespace = 'dynamodb'
        AND pr.resource_id = CONCAT('table/', t.table_name)
        AND pr.policy_type = 'TargetTrackingScaling'
        AND pr.scalable_dimension = 'dynamodb:table:ReadCapacityUnits')
    LEFT JOIN aws_applicationautoscaling_policies pw ON (pw.service_namespace = 'dynamodb'
        AND pw.resource_id = CONCAT('table/', t.table_name)
        AND pw.policy_type = 'TargetTrackingScaling'
        AND pw.scalable_dimension = 'dynamodb:table:WriteCapacityUnits');
"""

POINT_IN_TIME_RECOVERY = """
insert into aws_policy_results
select
    %s as execution_time,
    %s as framework,
    %s as check_id,
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
"""

DAX_ENCRYPTED_AT_REST = """
insert into aws_policy_results
select
    %s as execution_time,
    %s as framework,
    %s as check_id,
    'DynamoDB Accelerator (DAX) clusters should be encrypted at rest' as title,
    account_id,
    arn as resource_id,
  case when
    sse_description:Status is distinct from 'ENABLED'
    then 'fail'
    else 'pass'
  end as status
from aws_dax_clusters
"""
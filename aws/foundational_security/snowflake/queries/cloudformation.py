CLOUDFORMATION_STACK_NOTIFICATION_CHECK = """
INSERT INTO aws_policy_results
SELECT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'CloudFormation stacks should be integrated with Simple Notification Service (SNS)' AS "title",
  account_id,
  arn AS resource_id,
  case
  when ARRAY_SIZE(notification_arns) > 0 then 'pass'
  else 'fail'
  END
    AS status
FROM
  aws_cloudformation_stacks;
"""
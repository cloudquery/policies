{% macro cloudformation_stack_notification_check(framework, check_id) %}
INSERT INTO aws_policy_results
SELECT
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
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
{% endmacro %}
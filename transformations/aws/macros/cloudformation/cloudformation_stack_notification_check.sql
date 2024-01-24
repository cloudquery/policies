{% macro cloudformation_stack_notification_check(framework, check_id) %}
  {{ return(adapter.dispatch('cloudformation_stack_notification_check')(framework, check_id)) }}
{% endmacro %}

{% macro default__cloudformation_stack_notification_check(framework, check_id) %}{% endmacro %}

{% macro postgres__cloudformation_stack_notification_check(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'CloudFormation stacks should be integrated with Simple Notification Service (SNS)' AS "title",
  account_id,
  arn AS resource_id,
  case
  when array_length(notification_arns, 1) > 0 then 'pass'
  else 'fail'
  END
    AS status
FROM
  aws_cloudformation_stacks
{% endmacro %}

{% macro snowflake__cloudformation_stack_notification_check(framework, check_id) %}
select
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
  aws_cloudformation_stacks
{% endmacro %}

{% macro bigquery__cloudformation_stack_notification_check(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'CloudFormation stacks should be integrated with Simple Notification Service (SNS)' AS title,
  account_id,
  arn AS resource_id,
  case
  when ARRAY_LENGTH(notification_arns) > 0 then 'pass'
  else 'fail'
  END
    AS status
FROM {{ full_table_name("aws_cloudformation_stacks") }}
{% endmacro %}
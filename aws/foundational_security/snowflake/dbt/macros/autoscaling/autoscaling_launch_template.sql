{% macro autoscaling_launch_template(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Amazon EC2 Auto Scaling groups should use Amazon EC2 launch templates' AS "title",
  account_id,
  arn AS resource_id,
  case
  when LAUNCH_TEMPLATE::String is null then 'fail'
    else 'pass'
  END
    AS status
FROM
  aws_autoscaling_groups
{% endmacro %}
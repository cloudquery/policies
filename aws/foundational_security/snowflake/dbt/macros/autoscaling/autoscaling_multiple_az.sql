{% macro autoscaling_multiple_az(framework, check_id) %}
INSERT INTO aws_policy_results
SELECT
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Amazon EC2 Auto Scaling group should cover multiple Availability Zones' AS "title",
  account_id,
  arn AS resource_id,
  case
  when ARRAY_SIZE(availability_zones) > 1 then 'pass'
  else 'fail'
  END
    AS status
FROM
  aws_autoscaling_groups;
{% endmacro %}
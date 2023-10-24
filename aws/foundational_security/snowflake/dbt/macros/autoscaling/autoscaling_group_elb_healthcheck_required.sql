{% macro autoscaling_group_elb_healthcheck_required(framework, check_id) %}
INSERT INTO aws_policy_results
SELECT
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Auto Scaling groups associated with a Classic Load Balancer should use load balancer health checks' AS "title",
  account_id,
  arn AS resource_id,
  case
  when ARRAY_SIZE(load_balancer_names) = 0 and ARRAY_SIZE(target_group_arns) = 0 then 'fail'
  when health_check_type not like '%ELB%' then 'fail'
  else 'pass'
  END
    AS status
FROM
  aws_autoscaling_groups;
{% endmacro %}
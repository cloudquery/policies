{% macro autoscaling_launch_config_hop_limit(framework, check_id) %}
INSERT INTO aws_policy_results
SELECT
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Auto Scaling group launch configuration should not have a metadata response hop limit greater than 1' AS "title",
  account_id,
  arn AS resource_id,
  case
  when METADATA_OPTIONS:HttpPutResponseHopLimit > 1 then 'fail'
    else 'pass'
  END
    AS status
FROM
  aws_autoscaling_launch_configurations;
{% endmacro %}
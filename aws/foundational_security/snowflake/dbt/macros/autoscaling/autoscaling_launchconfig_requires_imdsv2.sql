{% macro autoscaling_launchconfig_requires_imdsv2(framework, check_id) %}
INSERT INTO aws_policy_results
SELECT
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Auto Scaling group launch configurations should configure EC2 instances to require Instance Metadata Service Version 2' AS "title",
  account_id,
  arn AS resource_id,
  case
  when METADATA_OPTIONS:HttpTokens = 'required' then 'pass'
    else 'fail'
  END
    AS status
FROM
  aws_autoscaling_launch_configurations;
{% endmacro %}
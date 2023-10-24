{% macro autoscaling_multiple_instance_types(framework, check_id) %}
INSERT INTO aws_policy_results
SELECT
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Auto Scaling groups should use multiple instance types in multiple Availability Zones' AS "title",
  aag.account_id,
  ditc.arn AS resource_id,
  ditc.status
FROM aws_autoscaling_groups as aag
JOIN (
  SELECT
    arn,
    CASE
      WHEN COUNT(DISTINCT instance.value:InstanceType) > 1 THEN 'pass'
      ELSE 'fail'
    END AS status
  FROM
    aws_autoscaling_groups AS aag,
    LATERAL FLATTEN(input => aag.INSTANCES) instance
  GROUP BY arn
) AS ditc ON aag.arn = ditc.arn;
{% endmacro %}
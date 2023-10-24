{% macro key_rotation_enabled(framework, check_id) %}
INSERT INTO aws_policy_results
SELECT
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'AWS KMS key rotation should be enabled' AS title,
  account_id,
  arn AS resource_id,
  CASE
  WHEN (rotation_enabled = false or rotation_enabled is null) AND key_manager = 'CUSTOMER' THEN 'fail'
  ELSE 'pass'
  END as status
FROM
  aws_kms_keys;
{% endmacro %}
{% macro key_rotation_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('key_rotation_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__key_rotation_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__key_rotation_enabled(framework, check_id) %}
select
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
  aws_kms_keys
{% endmacro %}

{% macro snowflake__key_rotation_enabled(framework, check_id) %}
select
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
  aws_kms_keys
{% endmacro %}
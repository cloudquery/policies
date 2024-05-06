{% macro key_rotation_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('key_rotation_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__key_rotation_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__key_rotation_enabled(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'AWS KMS key rotation should be enabled' AS title,
  akk.account_id,
  akk.arn AS resource_id,
  CASE
  WHEN (akkrs.key_rotation_enabled = false or akkrs.key_rotation_enabled is null) AND akk.key_manager = 'CUSTOMER' THEN 'fail'
  ELSE 'pass'
  END as status
FROM
  aws_kms_keys akk
LEFT JOIN
  aws_kms_key_rotation_statuses akkrs on akk.arn = akkrs.key_arn
{% endmacro %}

{% macro snowflake__key_rotation_enabled(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'AWS KMS key rotation should be enabled' AS title,
  akk.account_id,
  akk.arn AS resource_id,
  CASE
  WHEN (akkrs.key_rotation_enabled = false or akkrs.key_rotation_enabled is null) AND akk.key_manager = 'CUSTOMER' THEN 'fail'
  ELSE 'pass'
  END as status
FROM
  aws_kms_keys akk
LEFT JOIN
  aws_kms_key_rotation_statuses akkrs on akk.arn = akkrs.key_arn
{% endmacro %}

{% macro bigquery__key_rotation_enabled(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'AWS KMS key rotation should be enabled' AS title,
  akk.account_id,
  akk.arn AS resource_id,
  CASE
  WHEN (akkrs.key_rotation_enabled = false or akkrs.key_rotation_enabled is null) AND akk.key_manager = 'CUSTOMER' THEN 'fail'
  ELSE 'pass'
  END as status
FROM
  {{ full_table_name("aws_kms_keys") }} akk
LEFT JOIN
  {{ full_table_name("aws_kms_key_rotation_statuses") }} akkrs on akk.arn = akkrs.key_arn
{% endmacro %}

{% macro athena__key_rotation_enabled(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'AWS KMS key rotation should be enabled' AS title,
  akk.account_id,
  akk.arn AS resource_id,
  CASE
  WHEN (akkrs.key_rotation_enabled = false or akkrs.key_rotation_enabled is null) AND akk.key_manager = 'CUSTOMER' THEN 'fail'
  ELSE 'pass'
  END as status
FROM
  aws_kms_keys akk
LEFT JOIN
  aws_kms_key_rotation_statuses akkrs on akk.arn = akkrs.key_arn
{% endmacro %}
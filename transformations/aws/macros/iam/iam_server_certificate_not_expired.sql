{% macro iam_server_certificate_not_expired(framework, check_id) %}
  {{ return(adapter.dispatch('iam_server_certificate_not_expired')(framework, check_id)) }}
{% endmacro %}

{% macro default__iam_server_certificate_not_expired(framework, check_id) %}{% endmacro %}

{% macro postgres__iam_server_certificate_not_expired(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure that all the expired SSL/TLS certificates stored in
AWS IAM are removed' as title,
  account_id,
  arn AS resource_id,
  CASE
    WHEN expiration < (current_date - interval '1' second) THEN 'fail'
    ELSE 'pass'
  END AS status
FROM
  aws_iam_server_certificates
{% endmacro %}

{% macro snowflake__iam_server_certificate_not_expired(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure that all the expired SSL/TLS certificates stored in
AWS IAM are removed' as title,
  account_id,
  arn AS resource_id,
  CASE
    WHEN expiration < (current_date - interval '1 second') THEN 'fail'
    ELSE 'pass'
  END AS status
FROM
  aws_iam_server_certificates
{% endmacro %}

{% macro bigquery__iam_server_certificate_not_expired(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Ensure that all the expired SSL/TLS certificates stored in AWS IAM are removed' as title,
  account_id,
  arn AS resource_id,
  CASE
    WHEN expiration < (CURRENT_TIMESTAMP() - interval 1 second) THEN 'fail'
    ELSE 'pass'
  END AS status
FROM
  {{ full_table_name("aws_iam_server_certificates") }}
{% endmacro %}


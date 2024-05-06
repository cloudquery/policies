{% macro secrets_configured_with_automatic_rotation_should_rotate_successfully(framework, check_id) %}
  {{ return(adapter.dispatch('secrets_configured_with_automatic_rotation_should_rotate_successfully')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__secrets_configured_with_automatic_rotation_should_rotate_successfully(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Secrets Manager secrets configured with automatic rotation should rotate successfully' as title,
    account_id,
    arn as resource_id,
    case when
        (last_rotated_date is null and created_date > dateadd(day, -(rotation_rules:AutomaticallyAfterDays)::integer, current_timestamp()))
        or (last_rotated_date is not null and last_rotated_date > dateadd(day, -(rotation_rules:AutomaticallyAfterDays)::integer, current_timestamp()))
    then 'fail' else 'pass' end as status
from aws_secretsmanager_secrets
{% endmacro %}

{% macro postgres__secrets_configured_with_automatic_rotation_should_rotate_successfully(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Secrets Manager secrets configured with automatic rotation should rotate successfully' as title,
     account_id,
     arn as resource_id,
     case when
        (last_rotated_date is null and created_date < now() - INTERVAL '1 day' * (rotation_rules->>'AutomaticallyAfterDays')::integer)
        or (last_rotated_date is not null and last_rotated_date < now() - INTERVAL '1 day' * (rotation_rules->>'AutomaticallyAfterDays')::integer)
     then 'fail' else 'pass' end as status
 from aws_secretsmanager_secrets

{% endmacro %}

{% macro default__secrets_configured_with_automatic_rotation_should_rotate_successfully(framework, check_id) %}{% endmacro %}

{% macro bigquery__secrets_configured_with_automatic_rotation_should_rotate_successfully(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Secrets Manager secrets configured with automatic rotation should rotate successfully' as title,
     account_id,
     arn as resource_id,
     case when
        (last_rotated_date is null and created_date <  TIMESTAMP_SUB(CURRENT_TIMESTAMP(), (INTERVAL 1*(CAST(JSON_VALUE(rotation_rules.AutomaticallyAfterDays) AS INT64)) DAY)  ))
        or (last_rotated_date is not null and last_rotated_date <  TIMESTAMP_SUB(CURRENT_TIMESTAMP(), (INTERVAL 1*(CAST(JSON_VALUE(rotation_rules.AutomaticallyAfterDays) AS INT64)) DAY)  ))
     then 'fail' else 'pass' end as status
 from {{ full_table_name("aws_secretsmanager_secrets") }}
{% endmacro %}

{% macro athena__secrets_configured_with_automatic_rotation_should_rotate_successfully(framework, check_id) %}
SELECT
  '{{framework}}' AS framework,
  '{{check_id}}' AS check_id,
  'Secrets Manager secrets configured with automatic rotation should rotate successfully' AS title,
  account_id,
  arn AS resource_id,
  CASE
    WHEN
      (last_rotated_date IS NULL AND created_date > date_add('day', -CAST(json_extract_scalar(rotation_rules, '$.AutomaticallyAfterDays') AS INTEGER), current_timestamp))
      OR (last_rotated_date IS NOT NULL AND last_rotated_date > date_add('day', -CAST(json_extract_scalar(rotation_rules, '$.AutomaticallyAfterDays') AS INTEGER), current_timestamp))
    THEN 'fail'
    ELSE 'pass'
  END AS status
FROM aws_secretsmanager_secrets
{% endmacro %}
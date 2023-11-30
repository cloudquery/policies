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
                    
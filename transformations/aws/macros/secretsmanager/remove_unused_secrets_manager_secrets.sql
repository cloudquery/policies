{% macro remove_unused_secrets_manager_secrets(framework, check_id) %}
  {{ return(adapter.dispatch('remove_unused_secrets_manager_secrets')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__remove_unused_secrets_manager_secrets(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Remove unused Secrets Manager secrets' as title,
    account_id,
    arn as resource_id,
    case when
        (last_accessed_date is null and created_date > current_timestamp() - INTERVAL '90 days')
        or (last_accessed_date is not null and last_accessed_date > current_timestamp() - INTERVAL '90 days')
    then 'fail' else 'pass' end as status
from aws_secretsmanager_secrets
{% endmacro %}

{% macro postgres__remove_unused_secrets_manager_secrets(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Remove unused Secrets Manager secrets' as title,
    account_id,
    arn as resource_id,
    case when
        (last_accessed_date is null and created_date < now() - INTERVAL '90 days')
        or (last_accessed_date is not null and last_accessed_date < now() - INTERVAL '90 days')
    then 'fail' else 'pass' end as status
from aws_secretsmanager_secrets
{% endmacro %}

{% macro default__remove_unused_secrets_manager_secrets(framework, check_id) %}{% endmacro %}

{% macro bigquery__remove_unused_secrets_manager_secrets(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Remove unused Secrets Manager secrets' as title,
    account_id,
    arn as resource_id,
    case when
        (last_accessed_date is null and created_date < TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY))
        or (last_accessed_date is not null and last_accessed_date < TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY))
    then 'fail' else 'pass' end as status
from {{ full_table_name("aws_secretsmanager_secrets") }}
{% endmacro %}

{% macro athena__remove_unused_secrets_manager_secrets(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Remove unused Secrets Manager secrets' as title,
    account_id,
    arn as resource_id,
    case when
        (last_accessed_date is null and created_date > current_timestamp - INTERVAL '90' day)
        or (last_accessed_date is not null and last_accessed_date > current_timestamp - INTERVAL '90' day)
    then 'fail' else 'pass' end as status
from aws_secretsmanager_secrets
{% endmacro %}
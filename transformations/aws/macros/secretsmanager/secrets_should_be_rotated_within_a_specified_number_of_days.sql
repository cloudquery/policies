{% macro secrets_should_be_rotated_within_a_specified_number_of_days(framework, check_id) %}
  {{ return(adapter.dispatch('secrets_should_be_rotated_within_a_specified_number_of_days')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__secrets_should_be_rotated_within_a_specified_number_of_days(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Secrets Manager secrets should be rotated within a specified number of days' as title,
    account_id,
    arn as resource_id,
    case when
        (last_rotated_date is null and created_date > current_timestamp() - INTERVAL '90 days')
        or (last_rotated_date is not null and last_rotated_date > current_timestamp() - INTERVAL '90 days')
    then 'fail' else 'pass' end as status
from aws_secretsmanager_secrets
{% endmacro %}

{% macro postgres__secrets_should_be_rotated_within_a_specified_number_of_days(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Secrets Manager secrets should be rotated within a specified number of days' as title,
    account_id,
    arn as resource_id,
    case when
        (last_rotated_date is null and created_date < now() - INTERVAL '90 days')
        or (last_rotated_date is not null and last_rotated_date < now() - INTERVAL '90 days')
    then 'fail' else 'pass' end as status
from aws_secretsmanager_secrets
{% endmacro %}

{% macro default__secrets_should_be_rotated_within_a_specified_number_of_days(framework, check_id) %}{% endmacro %}

{% macro bigquery__secrets_should_be_rotated_within_a_specified_number_of_days(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Secrets Manager secrets should be rotated within a specified number of days' as title,
    account_id,
    arn as resource_id,
    case when
        (last_rotated_date is null and created_date < TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY))
        or (last_rotated_date is not null and last_rotated_date < TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY))
    then 'fail' else 'pass' end as status
from {{ full_table_name("aws_secretsmanager_secrets") }}
{% endmacro %}

{% macro snowflake__secrets_should_be_rotated_within_a_specified_number_of_days(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Secrets Manager secrets should be rotated within a specified number of days' as title,
    account_id,
    arn as resource_id,
    case when
        (last_rotated_date is null and created_date > current_timestamp - INTERVAL '90' day)
        or (last_rotated_date is not null and last_rotated_date > current_timestamp - INTERVAL '90' day)
    then 'fail' else 'pass' end as status
from aws_secretsmanager_secrets
{% endmacro %}
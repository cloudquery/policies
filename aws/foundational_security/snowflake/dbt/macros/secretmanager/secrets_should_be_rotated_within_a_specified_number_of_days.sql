{% macro secrets_should_be_rotated_within_a_specified_number_of_days(framework, check_id) %}
insert into aws_policy_results
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
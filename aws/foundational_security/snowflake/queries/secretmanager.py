
SECRETS_SHOULD_HAVE_AUTOMATIC_ROTATION_ENABLED = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Secrets Manager secrets should have automatic rotation enabled' as title,
    account_id,
    arn as resource_id,
    case when
        rotation_enabled is distinct from TRUE
    then 'fail' else 'pass' end as status
from aws_secretsmanager_secrets
"""

SECRETS_CONFIGURED_WITH_AUTOMATIC_ROTATION_SHOULD_ROTATE_SUCCESSFULLY = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Secrets Manager secrets configured with automatic rotation should rotate successfully' as title,
    account_id,
    arn as resource_id,
    case when
        (last_rotated_date is null and created_date > dateadd(day, -(rotation_rules:AutomaticallyAfterDays)::integer, current_timestamp()))
        or (last_rotated_date is not null and last_rotated_date > dateadd(day, -(rotation_rules:AutomaticallyAfterDays)::integer, current_timestamp()))
    then 'fail' else 'pass' end as status
from aws_secretsmanager_secrets
"""

REMOVE_UNUSED_SECRETS_MANAGER_SECRETS = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Remove unused Secrets Manager secrets' as title,
    account_id,
    arn as resource_id,
    case when
        (last_accessed_date is null and created_date > current_timestamp() - INTERVAL '90 days')
        or (last_accessed_date is not null and last_accessed_date > current_timestamp() - INTERVAL '90 days')
    then 'fail' else 'pass' end as status
from aws_secretsmanager_secrets
"""

SECRETS_SHOULD_BE_ROTATED_WITHIN_A_SPECIFIED_NUMBER_OF_DAYS = """
insert into aws_policy_results
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Secrets Manager secrets should be rotated within a specified number of days' as title,
    account_id,
    arn as resource_id,
    case when
        (last_rotated_date is null and created_date > current_timestamp() - INTERVAL '90 days')
        or (last_rotated_date is not null and last_rotated_date > current_timestamp() - INTERVAL '90 days')
    then 'fail' else 'pass' end as status
from aws_secretsmanager_secrets
"""

{% macro secrets_should_have_automatic_rotation_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Secrets Manager secrets should have automatic rotation enabled' as title,
    account_id,
    arn as resource_id,
    case when
        rotation_enabled is distinct from TRUE
    then 'fail' else 'pass' end as status
from aws_secretsmanager_secrets
{% endmacro %}
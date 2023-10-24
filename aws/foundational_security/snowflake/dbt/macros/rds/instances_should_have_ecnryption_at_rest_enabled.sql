{% macro instances_should_have_ecnryption_at_rest_enabled(framework, check_id) %}
insert into aws_policy_results
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS DB instances should have encryption at rest enabled' as title,
    account_id,
    arn AS resource_id,
    case when storage_encrypted != TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
{% endmacro %}
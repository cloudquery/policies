{% macro iam_authentication_should_be_configured_for_rds_instances(framework, check_id) %}
insert into aws_policy_results
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'IAM authentication should be configured for RDS instances' as title,
    account_id,
    arn AS resource_id,
    case when iam_database_authentication_enabled != TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
{% endmacro %}
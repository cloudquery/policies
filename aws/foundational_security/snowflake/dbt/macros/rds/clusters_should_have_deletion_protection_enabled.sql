{% macro clusters_should_have_deletion_protection_enabled(framework, check_id) %}
insert into aws_policy_results
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS clusters should have deletion protection enabled' as title,
    account_id,
    arn AS resource_id,
    case when deletion_protection != TRUE then 'fail' else 'pass' end as status
from aws_rds_clusters
{% endmacro %}
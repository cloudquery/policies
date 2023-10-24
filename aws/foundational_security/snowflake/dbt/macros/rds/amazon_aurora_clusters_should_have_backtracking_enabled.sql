{% macro amazon_aurora_clusters_should_have_backtracking_enabled(framework, check_id) %}
insert into aws_policy_results
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon Aurora clusters should have backtracking enabled' as title,
    account_id,
    arn AS resource_id,
    case when backtrack_window is null then 'fail' else 'pass' end as status
from aws_rds_clusters
where
    engine in ('aurora', 'aurora-mysql', 'mysql')
{% endmacro %}
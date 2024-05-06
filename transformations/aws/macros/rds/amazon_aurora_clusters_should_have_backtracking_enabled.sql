{% macro amazon_aurora_clusters_should_have_backtracking_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('amazon_aurora_clusters_should_have_backtracking_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__amazon_aurora_clusters_should_have_backtracking_enabled(framework, check_id) %}
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

{% macro postgres__amazon_aurora_clusters_should_have_backtracking_enabled(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Amazon Aurora clusters should have backtracking enabled' as title,
    account_id,
    arn AS resource_id,
    case when backtrack_window is null then 'fail' else 'pass' end as status
from aws_rds_clusters
where
    engine in ('aurora', 'aurora-mysql', 'mysql')
{% endmacro %}

{% macro default__amazon_aurora_clusters_should_have_backtracking_enabled(framework, check_id) %}{% endmacro %}

{% macro bigquery__amazon_aurora_clusters_should_have_backtracking_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon Aurora clusters should have backtracking enabled' as title,
    account_id,
    arn AS resource_id,
    case when backtrack_window is null then 'fail' else 'pass' end as status
from {{ full_table_name("aws_rds_clusters") }}
where
    engine in ('aurora', 'aurora-mysql', 'mysql')
{% endmacro %}

{% macro athena__amazon_aurora_clusters_should_have_backtracking_enabled(framework, check_id) %}
SELECT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'Amazon Aurora clusters should have backtracking enabled' AS title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN backtrack_window IS NULL THEN 'fail' 
        ELSE 'pass' 
    END AS status
FROM aws_rds_clusters
WHERE engine IN ('aurora', 'aurora-mysql', 'mysql')
{% endmacro %}
{% macro clusters_should_have_7_days_backup_retention(framework, check_id) %}
insert into aws_policy_results
SELECT 
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon DocumentDB clusters should have an adequate backup retention period' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN backup_retention_period >= 7 THEN 'pass'
        ELSE 'fail'
    END as status
FROM aws_docdb_clusters
{% endmacro %}
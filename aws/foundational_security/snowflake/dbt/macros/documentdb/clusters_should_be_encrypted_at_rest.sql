{% macro clusters_should_be_encrypted_at_rest(framework, check_id) %}
insert into aws_policy_results
SELECT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon DocumentDB clusters should be encrypted at rest' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN storage_encrypted = false THEN 'fail'
        ELSE 'pass'
    END as status
FROM aws_docdb_clusters
{% endmacro %}
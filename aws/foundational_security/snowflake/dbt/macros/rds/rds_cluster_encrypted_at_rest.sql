{% macro rds_cluster_encrypted_at_rest(framework, check_id) %}
insert into aws_policy_results
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS DB clusters should be encrypted at rest' as title,
    account_id,
    arn AS resource_id,
    CASE
        WHEN storage_encrypted THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_rds_clusters;
{% endmacro %}
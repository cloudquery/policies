{% macro rds_cluster_default_admin_check(framework, check_id) %}
insert into aws_policy_results
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS Database clusters should use a custom administrator username' as title,
    account_id,
    arn AS resource_id,
    CASE
        WHEN master_username NOT IN ('admin', 'root', 'administrator', 'master', 'sa', 'awsuser') THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_rds_clusters;
{% endmacro %}
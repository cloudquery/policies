{% macro rds_cluster_default_admin_check(framework, check_id) %}
  {{ return(adapter.dispatch('rds_cluster_default_admin_check')(framework, check_id)) }}
{% endmacro %}

{% macro default__rds_cluster_default_admin_check(framework, check_id) %}{% endmacro %}

{% macro postgres__rds_cluster_default_admin_check(framework, check_id) %}
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
    aws_rds_clusters
{% endmacro %}

{% macro snowflake__rds_cluster_default_admin_check(framework, check_id) %}
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
    aws_rds_clusters
{% endmacro %}

{% macro bigquery__rds_cluster_default_admin_check(framework, check_id) %}
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
    {{ full_table_name("aws_rds_clusters") }}
{% endmacro %}
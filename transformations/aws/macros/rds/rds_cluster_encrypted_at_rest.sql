{% macro rds_cluster_encrypted_at_rest(framework, check_id) %}
  {{ return(adapter.dispatch('rds_cluster_encrypted_at_rest')(framework, check_id)) }}
{% endmacro %}

{% macro default__rds_cluster_encrypted_at_rest(framework, check_id) %}{% endmacro %}

{% macro postgres__rds_cluster_encrypted_at_rest(framework, check_id) %}
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
    aws_rds_clusters
{% endmacro %}

{% macro snowflake__rds_cluster_encrypted_at_rest(framework, check_id) %}
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
    aws_rds_clusters
{% endmacro %}

{% macro bigquery__rds_cluster_encrypted_at_rest(framework, check_id) %}
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
    {{ full_table_name("aws_rds_clusters") }}
{% endmacro %}

{% macro athena__rds_cluster_encrypted_at_rest(framework, check_id) %}
SELECT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'RDS DB clusters should be encrypted at rest' AS title,
    account_id,
    arn AS resource_id,
    CASE
        WHEN storage_encrypted THEN 'pass'
        ELSE 'fail'
    END AS status
FROM aws_rds_clusters
{% endmacro %}
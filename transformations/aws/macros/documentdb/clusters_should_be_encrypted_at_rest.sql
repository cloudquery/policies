{% macro clusters_should_be_encrypted_at_rest(framework, check_id) %}
  {{ return(adapter.dispatch('clusters_should_be_encrypted_at_rest')(framework, check_id)) }}
{% endmacro %}

{% macro default__clusters_should_be_encrypted_at_rest(framework, check_id) %}{% endmacro %}

{% macro postgres__clusters_should_be_encrypted_at_rest(framework, check_id) %}
select
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

{% macro snowflake__clusters_should_be_encrypted_at_rest(framework, check_id) %}
select
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

{% macro bigquery__clusters_should_be_encrypted_at_rest(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon DocumentDB clusters should be encrypted at rest' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN storage_encrypted = false THEN 'fail'
        ELSE 'pass'
    END as status
FROM {{ full_table_name("aws_docdb_clusters") }}
{% endmacro %}

{% macro athena__clusters_should_be_encrypted_at_rest(framework, check_id) %}
select
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
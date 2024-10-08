{% macro storage_buckets_without_uniform_bucket_level_access(framework, check_id) %}
  {{ return(adapter.dispatch('storage_buckets_without_uniform_bucket_level_access')(framework, check_id)) }}
{% endmacro %}

{% macro default__storage_buckets_without_uniform_bucket_level_access(framework, check_id) %}{% endmacro %}

{% macro postgres__storage_buckets_without_uniform_bucket_level_access(framework, check_id) %}
select 
                "name"                                                                    AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that Cloud Storage buckets have uniform bucket-level access enabled (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                    (uniform_bucket_level_access->>'Enabled')::boolean = FALSE
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_storage_buckets
{% endmacro %}

{% macro snowflake__storage_buckets_without_uniform_bucket_level_access(framework, check_id) %}
select 
                name                                                                    AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that Cloud Storage buckets have uniform bucket-level access enabled (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                    (uniform_bucket_level_access:Enabled)::boolean = FALSE
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_storage_buckets
{% endmacro %}

{% macro bigquery__storage_buckets_without_uniform_bucket_level_access(framework, check_id) %}
select 
                name                                                                    AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that Cloud Storage buckets have uniform bucket-level access enabled (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                    CAST( JSON_VALUE(uniform_bucket_level_access.Enabled) AS BOOL) = FALSE
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM {{ full_table_name("gcp_storage_buckets") }}
{% endmacro %}
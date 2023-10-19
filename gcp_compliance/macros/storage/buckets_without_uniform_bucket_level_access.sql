{% macro storage_buckets_without_uniform_bucket_level_access(framework, check_id) %}
    select 
                "name"                                                                    AS resource_id,
                _cq_sync_time As execution_time,
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
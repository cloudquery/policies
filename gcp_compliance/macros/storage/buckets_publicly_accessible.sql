{% macro storage_buckets_publicly_accessible(framework, check_id) %}
    select 
                "name"                                                                    AS resource_id,
                CURRENT_TIMESTAMP As execution_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that Cloud Storage bucket is not anonymously or publicly accessible (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                            member LIKE '%allUsers%'
                        OR member LIKE '%allAuthenticatedUsers%'
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM {{ ref('gcp_public_buckets_accesses') }}
{% endmacro %}
{% macro logging_not_configured_across_services_and_users(framework, check_id) %}
    select DISTINCT 
                service                                                                    AS resource_id,
                CURRENT_TIMESTAMP As execution_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that Cloud Audit Logging is configured properly across all services and all users from a project (Automated)' AS title,
                "project_id"                                                                AS project_id,
                CASE
                WHEN
                        valid_types = 3
                    THEN 'pass'
                ELSE 'fail'
                END AS status
    FROM {{ ref('valid_log_types') }}
{% endmacro %}
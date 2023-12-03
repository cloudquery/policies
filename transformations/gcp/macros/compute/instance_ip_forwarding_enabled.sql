{% macro compute_instance_ip_forwarding_enabled(framework, check_id) %}
    select 
                "name"                                                                    AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that IP forwarding is not enabled on Instances (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                    can_ip_forward = TRUE
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_compute_instances
{% endmacro %}
{% macro compute_rdp_access_permitted(framework, check_id) %}
    select
                "name"                                                                   AS resource_id,
                CURRENT_TIMESTAMP As execution_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that RDP access is restricted from the Internet (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                        direction = 'INGRESS'
                        AND (ip_protocol = 'tcp'
                        OR ip_protocol = 'all')
                        AND '0.0.0.0/0' = ANY (source_ranges)
                        AND (3986 BETWEEN range_start AND range_end
                        OR '3986' = single_port
                        OR CARDINALITY(ports) = 0
                        OR ports IS NULL)
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM {{ ref('gcp_firewall_allowed_rules') }}
{% endmacro %}
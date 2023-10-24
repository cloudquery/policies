{% macro compute_legacy_network_exist(framework, check_id) %}
    select 
                "id"::text                                                                    AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure legacy networks do not exist for a project (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                    dnssec_config->>'state' != 'on'
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_dns_managed_zones
{% endmacro %}
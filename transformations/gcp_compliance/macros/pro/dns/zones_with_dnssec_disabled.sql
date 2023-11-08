{% macro dns_zones_with_dnssec_disabled(framework, check_id) %}
    select
    DISTINCT 
                "id"::text                                                                                   AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that DNSSEC is enabled for Cloud DNS (Automated)' AS title,
                project_id                                                                             AS project_id,
                CASE
           WHEN
               visibility != 'private'
               and ((dnssec_config is null) or (dnssec_config->>'state' = 'off'))
               THEN 'fail'
           ELSE 'pass'
           END AS status
    FROM gcp_dns_managed_zones
{% endmacro %}
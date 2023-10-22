{% macro dns_key_signing_with_rsasha1(framework, check_id) %}
    select
    DISTINCT 
                gdmz.id::text                                                                                   AS resource_id,
                gdmz._cq_sync_time As execution_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that DNSSEC is enabled for Cloud DNS (Automated)' AS title,
                gdmz.project_id                                                                             AS project_id,
                CASE
                    WHEN
                                gdmzdcdks->>'keyType' = 'keySigning'
                            AND gdmzdcdks->>'algorithm' = 'rsasha1'
                        THEN 'fail'
                    ELSE 'pass'
                    END AS status
    FROM gcp_dns_managed_zones gdmz, JSONB_ARRAY_ELEMENTS(gdmz.dnssec_config->'defaultKeySpecs') AS gdmzdcdks
{% endmacro %}
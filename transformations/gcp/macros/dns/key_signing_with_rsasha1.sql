{% macro dns_key_signing_with_rsasha1(framework, check_id) %}
  {{ return(adapter.dispatch('dns_key_signing_with_rsasha1')(framework, check_id)) }}
{% endmacro %}

{% macro default__dns_key_signing_with_rsasha1(framework, check_id) %}{% endmacro %}

{% macro postgres__dns_key_signing_with_rsasha1(framework, check_id) %}
select
    DISTINCT 
                gdmz.id::text                                                                                   AS resource_id,
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

{% macro snowflake__dns_key_signing_with_rsasha1(framework, check_id) %}
select
    DISTINCT 
                gdmz.id::text                                                                                   AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that DNSSEC is enabled for Cloud DNS (Automated)' AS title,
                gdmz.project_id                                                                             AS project_id,
                CASE
                    WHEN
                                gdmzdcdks.value:keyType = 'keySigning'
                            AND gdmzdcdks.value:algorithm = 'rsasha1'
                        THEN 'fail'
                    ELSE 'pass'
                    END AS status
    FROM gcp_dns_managed_zones gdmz, 
    LATERAL FLATTEN(input => gdmz.dnssec_config:defaultKeySpecs) AS gdmzdcdks
{% endmacro %}

{% macro bigquery__dns_key_signing_with_rsasha1(framework, check_id) %}
select
    DISTINCT 
                CAST(gdmz.id AS STRING)                                                                           AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that DNSSEC is enabled for Cloud DNS (Automated)' AS title,
                gdmz.project_id                                                                             AS project_id,
                CASE
                    WHEN
                                JSON_VALUE(gdmzdcdks.keyType) = 'keySigning'
                            AND JSON_VALUE(gdmzdcdks.algorithm) = 'rsasha1'
                        THEN 'fail'
                    ELSE 'pass'
                    END AS status
    FROM {{ full_table_name("gcp_dns_managed_zones") }} gdmz,
    UNNEST(JSON_QUERY_ARRAY(gdmz.dnssec_config.defaultKeySpecs)) AS gdmzdcdks 
{% endmacro %}
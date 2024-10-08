{% macro compute_legacy_network_exist(framework, check_id) %}
  {{ return(adapter.dispatch('compute_legacy_network_exist')(framework, check_id)) }}
{% endmacro %}

{% macro default__compute_legacy_network_exist(framework, check_id) %}{% endmacro %}

{% macro postgres__compute_legacy_network_exist(framework, check_id) %}
select 
                "id"::text                                                                    AS resource_id,
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

{% macro snowflake__compute_legacy_network_exist(framework, check_id) %}
select 
                id::text                                                                    AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure legacy networks do not exist for a project (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                    dnssec_config:state != 'on'
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_dns_managed_zones
{% endmacro %}

{% macro bigquery__compute_legacy_network_exist(framework, check_id) %}
select 
                CAST(id AS STRING)                                                                    AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure legacy networks do not exist for a project (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                    JSON_VALUE(dnssec_config.state) != 'on'
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM {{ full_table_name("gcp_dns_managed_zones") }}
{% endmacro %}
{% macro logging_dns_logging_disabled(framework, check_id) %}
  {{ return(adapter.dispatch('logging_dns_logging_disabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__logging_dns_logging_disabled(framework, check_id) %}{% endmacro %}

{% macro postgres__logging_dns_logging_disabled(framework, check_id) %}
select DISTINCT 
                gcn.name                                                                    AS resource_id,
                gcn._cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that Cloud DNS logging is enabled for all VPC networks (Automated)' AS title,
                gcn.project_id                                                                AS project_id,
                CASE
                    WHEN
                        gdp.enable_logging = FALSE
                        THEN 'fail'
                    ELSE 'pass'
                    END                                                                     AS status
    FROM gcp_dns_policies gdp, JSONB_ARRAY_ELEMENTS(gdp.networks) AS gdpn
    JOIN gcp_compute_networks gcn ON gcn.self_link = REPLACE(gdpn->>'networkUrl', 'compute.googleapis', 'www.googleapis')
{% endmacro %}

{% macro snowflake__logging_dns_logging_disabled(framework, check_id) %}
select DISTINCT 
                gcn.name                                                                    AS resource_id,
                gcn._cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that Cloud DNS logging is enabled for all VPC networks (Automated)' AS title,
                gcn.project_id                                                                AS project_id,
                CASE
                    WHEN
                        gdp.enable_logging = FALSE
                        THEN 'fail'
                    ELSE 'pass'
                    END                                                                     AS status
    FROM gcp_dns_policies gdp,
    LATERAL FLATTEN(input => gdp.networks) AS gdpn
    JOIN gcp_compute_networks gcn ON gcn.self_link = REPLACE(gdpn.value:networkUrl, 'compute.googleapis', 'www.googleapis')
{% endmacro %}
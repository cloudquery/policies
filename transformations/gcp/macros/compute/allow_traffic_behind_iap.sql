{% macro compute_allow_traffic_behind_iap(framework, check_id) %}
  {{ return(adapter.dispatch('compute_allow_traffic_behind_iap')(framework, check_id)) }}
{% endmacro %}

{% macro default__compute_allow_traffic_behind_iap(framework, check_id) %}{% endmacro %}

{% macro postgres__compute_allow_traffic_behind_iap(framework, check_id) %}
WITH expanded_firewalls AS (
    SELECT * FROM gcp_compute_firewalls gcf, JSONB_ARRAY_ELEMENTS(gcf.allowed) AS a
)
SELECT
        DISTINCT
        gcf.name AS resource_id,
        '{{framework}}' AS framework,
        '{{check_id}}' AS check_id,
        'GCP CIS3.10 Ensure Firewall Rules for instances behind Identity Aware Proxy (IAP) only allow the traffic from Google Cloud Loadbalancer (GCLB) Health Check and Proxy Addresses (Manual)' AS title,
        gcf.project_id AS project_id,
        CASE
            WHEN
                NOT ARRAY['35.191.0.0/16', '130.211.0.0/22'] <@ gcf.source_ranges
                AND NOT (gcf.value->>'I_p_protocol' = 'tcp'
                AND ARRAY(SELECT JSONB_ARRAY_ELEMENTS_TEXT(gcf.value->'ports')) @> ARRAY['80'])
            THEN 'fail'
            ELSE 'pass'
        END AS status
    FROM expanded_firewalls AS gcf
{% endmacro %}

{% macro snowflake__compute_allow_traffic_behind_iap(framework, check_id) %}
WITH expanded_firewalls AS (
    SELECT * FROM gcp_compute_firewalls gcf, LATERAL FLATTEN(input => gcf.allowed) AS a
)
SELECT
        DISTINCT
        gcf.name AS resource_id,
        '{{framework}}' AS framework,
        '{{check_id}}' AS check_id,
        'GCP CIS3.10 Ensure Firewall Rules for instances behind Identity Aware Proxy (IAP) only allow the traffic from Google Cloud Loadbalancer (GCLB) Health Check and Proxy Addresses (Manual)' AS title,
        gcf.project_id AS project_id,
        CASE
            WHEN
                NOT (array_contains('35.191.0.0/16'::variant, gcf.source_ranges) AND
                array_contains('130.211.0.0/22'::variant, gcf.source_ranges))
                AND NOT (gcf.value:I_p_protocol = 'tcp')
                AND array_contains('80'::variant, p.value)
            THEN 'fail'
            ELSE 'pass'
        END AS status
    FROM expanded_firewalls AS gcf,
    LATERAL FLATTEN(gcf.value:ports) p
{% endmacro %}

{% macro bigquery__compute_allow_traffic_behind_iap(framework, check_id) %}
WITH expanded_firewalls AS (
    SELECT * FROM {{ full_table_name("gcp_compute_firewalls") }} gcf, 
    UNNEST(JSON_QUERY_ARRAY(allowed)) AS a
)
SELECT
        DISTINCT
        gcf.name AS resource_id,
        '{{framework}}' AS framework,
        '{{check_id}}' AS check_id,
        'GCP CIS3.10 Ensure Firewall Rules for instances behind Identity Aware Proxy (IAP) only allow the traffic from Google Cloud Loadbalancer (GCLB) Health Check and Proxy Addresses (Manual)' AS title,
        gcf.project_id AS project_id,
        CASE
            WHEN
                NOT ( '35.191.0.0/16' in UNNEST(gcf.source_ranges) AND '130.211.0.0/22' in UNNEST(gcf.source_ranges))
                AND NOT (JSON_VALUE(gcf.a.I_p_protocol) = 'tcp'
                AND IFNULL(CAST(JSON_VALUE(gcf.a.ports) AS INT64), 0) = 80)
            THEN 'fail'
            ELSE 'pass'
        END AS status
    FROM expanded_firewalls AS gcf
{% endmacro %}
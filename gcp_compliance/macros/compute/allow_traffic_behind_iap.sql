{% macro compute_allow_traffic_behind_iap(framework, check_id) %}
    SELECT
        DISTINCT
        gcf.name AS resource_id,
        gcf._cq_sync_time AS sync_time,
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
    FROM {{ ref('expanded_firewalls') }} AS gcf
 {% endmacro %}
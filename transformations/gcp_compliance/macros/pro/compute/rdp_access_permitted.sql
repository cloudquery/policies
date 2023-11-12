{% macro compute_rdp_access_permitted(framework, check_id) %}
  {{ return(adapter.dispatch('compute_rdp_access_permitted')(framework, check_id)) }}
{% endmacro %}

{% macro default__compute_rdp_access_permitted(framework, check_id) %}{% endmacro %}

{% macro postgres__compute_rdp_access_permitted(framework, check_id) %}
WITH combined AS (
    SELECT * FROM gcp_compute_firewalls gcf, JSONB_ARRAY_ELEMENTS(gcf.allowed) AS a
),
gcp_firewall_allowed_rules AS (
    SELECT
    gcf._cq_sync_time,
    gcf.project_id,
    gcf."name",
    gcf.network,
    gcf.self_link AS link,
    gcf.direction,
    gcf.source_ranges,
    gcf.value->>'I_p_protocol' as ip_protocol,
    ARRAY(SELECT JSONB_ARRAY_ELEMENTS_TEXT(gcf.value->'ports')) as ports,
    pr.range_start,
    pr.range_end,
    pr.single_port
FROM combined AS gcf
    LEFT JOIN (
        SELECT project_id, id, range_start, range_end, single_port
        FROM
            (
                SELECT
                    project_id, id,
                    split_part(p, '-', 1) :: INTEGER AS range_start,
                    split_part(p, '-', 2) :: INTEGER AS range_end,
                    NULL AS single_port
                FROM ( SELECT project_id, id, JSONB_ARRAY_ELEMENTS_TEXT(value->'ports') AS p
                    FROM combined) AS f
                WHERE p ~ '^[0-9]+(-[0-9]+)$'
                UNION
                SELECT project_id, id, NULL AS range_start, NULL AS range_end, p AS single_port
                FROM ( SELECT project_id, id, JSONB_ARRAY_ELEMENTS_TEXT(value->'ports') AS p
                    FROM combined) AS f
                WHERE p ~ '^[0-9]*$') AS s
    ) AS pr
    ON gcf.project_id = pr.project_id AND gcf.id = pr.id
)
select
                "name"                                                                   AS resource_id,
                _cq_sync_time As sync_time,
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
    FROM gcp_firewall_allowed_rules
{% endmacro %}

{% macro snowflake__compute_rdp_access_permitted(framework, check_id) %}
select
                name                                                                   AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that RDP access is restricted from the Internet (Automated)' AS title,
                project_id                                                                AS project_id,
                'pass' as status
    FROM gcp_compute_firewalls
 WHERE 1=0
{% endmacro %}
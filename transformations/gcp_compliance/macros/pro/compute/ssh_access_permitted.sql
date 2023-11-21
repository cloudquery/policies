{% macro compute_ssh_access_permitted(framework, check_id) %}
  {{ return(adapter.dispatch('compute_ssh_access_permitted')(framework, check_id)) }}
{% endmacro %}

{% macro default__compute_ssh_access_permitted(framework, check_id) %}{% endmacro %}

{% macro postgres__compute_ssh_access_permitted(framework, check_id) %}
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
                'Ensure that SSH access is restricted from the internet (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
           WHEN
                       direction = 'INGRESS'
                   AND (ip_protocol = 'tcp'
                   OR ip_protocol = 'all')
                   AND '0.0.0.0/0' = ANY (source_ranges)
                   AND (22 BETWEEN range_start AND range_end
                   OR '22' = single_port
                   OR CARDINALITY(ports) = 0
                   OR ports IS NULL)
               THEN 'fail'
           ELSE 'pass'
           END AS status
    FROM gcp_firewall_allowed_rules
{% endmacro %}

{% macro snowflake__compute_ssh_access_permitted(framework, check_id) %}
WITH combined AS (
   SELECT * FROM gcp_compute_firewalls gcf,
  LATERAL FLATTEN(input => allowed) AS a
),
gcp_firewall_allowed_rules AS (
    SELECT
    gcf._cq_sync_time,
    gcf.project_id,
    gcf.name,
    gcf.network,
    gcf.self_link AS link,
    gcf.direction,
    gcf.source_ranges,
    gcf.value:I_p_protocol as ip_protocol,
    gcf.value:ports as ports,
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
                    SPLIT_PART(p, '-', 1) :: INTEGER AS range_start,
                    SPLIT_PART(p, '-', 2) :: INTEGER AS range_end,
                    NULL AS single_port
                FROM ( SELECT project_id, id, 
                      p.value as p
                    FROM combined,
                     LATERAL FLATTEN(input => value:ports) AS p) AS f
                WHERE p REGEXP '^[0-9]+(-[0-9]+)$'
                UNION
                SELECT project_id, id, NULL AS range_start, NULL AS range_end, p AS single_port
                FROM ( SELECT project_id, id, p.value as p
                    FROM combined,
                     LATERAL FLATTEN(input => value:ports) AS p) AS f
                WHERE p REGEXP '^[0-9]*$') AS s
    ) AS pr
    ON gcf.project_id = pr.project_id AND gcf.id = pr.id
)
select
                name                                                                   AS resource_id,
                _cq_sync_time As sync_time, 
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that SSH access is restricted from the internet (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
           WHEN
                       direction = 'INGRESS'
                   AND (ip_protocol = 'tcp'
                   OR ip_protocol = 'all')
                   AND ARRAY_CONTAINS('0.0.0.0/0'::variant, source_ranges)
                   AND (22 BETWEEN range_start AND range_end
                   OR '22' = single_port
                   OR ARRAY_SIZE(ports) = 0
                   OR ports IS NULL)
               THEN 'fail'
           ELSE 'pass'
           END AS status
    FROM gcp_firewall_allowed_rules
{% endmacro %}

{% macro bigquery__compute_ssh_access_permitted(framework, check_id) %}
WITH combined AS (
    SELECT * FROM {{ full_table_name("gcp_compute_firewalls") }} gcf, 
    UNNEST(JSON_QUERY_ARRAY(gcf.allowed)) AS a
),
gcp_firewall_allowed_rules AS (
SELECT 
    gcf._cq_sync_time,
    gcf.project_id,
    gcf.name,
    gcf.network,
    gcf.self_link AS link,
    gcf.direction,
    gcf.source_ranges,
    JSON_VALUE(gcf.a.I_p_protocol) as ip_protocol,
    JSON_QUERY_ARRAY(gcf.a.ports) AS ports,
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
                    SPLIT(p, '-')[0] AS range_start,
                    SPLIT(p, '-')[1] AS range_end,
                    NULL AS single_port
                FROM ( SELECT project_id, id, JSON_VALUE(ports) AS p
                    FROM combined,
                    UNNEST(JSON_QUERY_ARRAY(a.ports)) AS ports
                    ) AS f
                WHERE REGEXP_CONTAINS(p, r'^[0-9]+(-[0-9]+)$')
                UNION all
                SELECT project_id, id, NULL AS range_start, NULL AS range_end, p AS single_port
                FROM ( SELECT project_id, id, JSON_VALUE(ports) AS p
                    FROM combined,
                    UNNEST(JSON_QUERY_ARRAY(a.ports)) AS ports
                    ) AS f
                WHERE REGEXP_CONTAINS(p, r'^[0-9]*$')) AS s
    ) AS pr
    ON gcf.project_id = pr.project_id AND gcf.id = pr.id
)
select distinct
                name                                                                   AS resource_id,
                _cq_sync_time As sync_time, 
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that SSH access is restricted from the internet (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
           WHEN
                       direction = 'INGRESS'
                   AND (ip_protocol = 'tcp'
                   OR ip_protocol = 'all')
                   AND '0.0.0.0/0' in UNNEST(source_ranges)
                   AND (22 BETWEEN CAST(range_start AS INT64) AND CAST(range_end AS INT64)
                   OR '22' = single_port
                   OR ARRAY_LENGTH(ports) = 0
                   OR ports IS NULL)
               THEN 'fail'
           ELSE 'pass'
           END AS status
    FROM gcp_firewall_allowed_rules
{% endmacro %}
{% macro daemonset_cpu_request(framework, check_id) %}
  {{ return(adapter.dispatch('daemonset_cpu_request')(framework, check_id)) }}
{% endmacro %}

{% macro default__daemonset_cpu_request(framework, check_id) %}{% endmacro %}

{% macro postgres__daemonset_cpu_request(framework, check_id) %}
-- Join every row in the daemonset table with its json array of containers.
WITH daemonset_containers AS (SELECT uid, value AS container 
                               FROM k8s_apps_daemon_sets
                               CROSS JOIN jsonb_array_elements(spec_template->'spec'->'containers') AS value)

select uid                              AS resource_id,
        '{{framework}}'                     AS framework,
        '{{check_id}}'                      AS check_id,
        'Daemonset enforces cpu requests' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
        CASE
            WHEN
                  -- Every container needs to have a CPU request for the check to pass
                  (SELECT COUNT(*) FROM daemonset_containers WHERE daemonset_containers.uid = k8s_apps_daemon_sets.uid AND
                  daemonset_containers.container->'resources'->'requests'->>'cpu' IS NULL) > 0
                THEN 'fail'
                ELSE 'pass'
            END                          AS status
FROM k8s_apps_daemon_sets
{% endmacro %}

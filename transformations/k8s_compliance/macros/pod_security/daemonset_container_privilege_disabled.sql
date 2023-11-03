{% macro daemonset_container_privilege_disabled(framework, check_id) %}
  {{ return(adapter.dispatch('daemonset_container_privilege_disabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__daemonset_container_privilege_disabled(framework, check_id) %}{% endmacro %}

{% macro postgres__daemonset_container_privilege_disabled(framework, check_id) %}
WITH daemonset_containers AS (SELECT uid, value AS container 
                               FROM k8s_apps_daemon_sets
                               CROSS JOIN jsonb_array_elements(spec_template->'spec'->'containers') AS value)

select uid                              AS resource_id,
      '{{framework}}'                      AS framework,
      '{{check_id}}'                       AS check_id,
      'DaemonSet containers privileges disabled' AS title,
      context                           AS context,
      namespace                         AS namespace,
      name                              AS resource_name,
      CASE WHEN
          (SELECT COUNT(*) FROM daemonset_containers WHERE daemonset_containers.uid = k8s_apps_daemon_sets.uid AND
            daemonset_containers.container->'securityContext'->>'privileged' = 'true') > 0
          THEN 'fail'
          ELSE 'pass'
          END                          AS status
FROM k8s_apps_daemon_sets
{% endmacro %}

{% macro pod_volume_host_path(framework, check_id) %}
  {{ return(adapter.dispatch('pod_volume_host_path')(framework, check_id)) }}
{% endmacro %}

{% macro default__pod_volume_host_path(framework, check_id) %}{% endmacro %}

{% macro postgres__pod_volume_host_path(framework, check_id) %}
WITH pod_volumes AS (SELECT uid, value AS volumes
                     FROM k8s_core_pods
                     CROSS JOIN jsonb_array_elements(spec_volumes) AS value)

select uid                              AS resource_id,
            '{{framework}}'                      AS framework,
            '{{check_id}}'                       AS check_id,
            'Pod volume don''t have a hostPath'            AS title,
            context                           AS context,
            namespace                         AS namespace,
            name                              AS resource_name,
            CASE WHEN
               (SELECT COUNT(*) FROM pod_volumes WHERE pod_volumes.uid = k8s_core_pods.uid AND
                 pod_volumes.volumes->>'hostPath' IS NOT NULL) > 0
               THEN 'fail'
               ELSE 'pass'
               END                          AS status
FROM k8s_core_pods;
{% endmacro %}

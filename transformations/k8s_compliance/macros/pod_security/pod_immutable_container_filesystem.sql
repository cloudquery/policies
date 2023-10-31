{% macro pod_immutable_container_filesystem(framework, check_id) %}
  {{ return(adapter.dispatch('pod_immutable_container_filesystem')(framework, check_id)) }}
{% endmacro %}

{% macro default__pod_immutable_container_filesystem(framework, check_id) %}{% endmacro %}

{% macro postgres__pod_immutable_container_filesystem(framework, check_id) %}
WITH pod_containers AS (SELECT uid, value AS container 
                        FROM k8s_core_pods
                        CROSS JOIN jsonb_array_elements(spec_containers) AS value)

select uid                              AS resource_id,
        '{{framework}}'                      AS framework,
        '{{check_id}}'                       AS check_id,
        'Pod container filesystem is read-ony' AS title,
        context                           AS context,
        namespace                         AS namespace,
        name                              AS resource_name,
        CASE WHEN
            (SELECT COUNT(*) FROM pod_containers WHERE pod_containers.uid = k8s_core_pods.uid AND
              pod_containers.container->'securityContext'->>'readOnlyRootFilesystem' IS DISTINCT FROM 'true') > 0
            THEN 'fail'
            ELSE 'pass'
            END                          AS status
FROM k8s_core_pods {% endmacro %}

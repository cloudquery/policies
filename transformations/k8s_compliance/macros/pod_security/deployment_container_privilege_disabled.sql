{% macro deployment_container_privilege_disabled(framework, check_id) %}
  {{ return(adapter.dispatch('deployment_container_privilege_disabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__deployment_container_privilege_disabled(framework, check_id) %}{% endmacro %}

{% macro postgres__deployment_container_privilege_disabled(framework, check_id) %}
WITH deployment_containers AS (SELECT uid, value AS container 
                               FROM k8s_apps_deployments
                               CROSS JOIN jsonb_array_elements(spec_template->'spec'->'containers') AS value)

select uid                              AS resource_id,
      '{{framework}}'                      AS framework,
      '{{check_id}}'                       AS check_id,
      'Deployments privileges disabled' AS title,
      context                           AS context,
      namespace                         AS namespace,
      name                              AS resource_name,
      CASE WHEN
          (SELECT COUNT(*) FROM deployment_containers WHERE deployment_containers.uid = k8s_apps_deployments.uid AND
            deployment_containers.container->'securityContext'->>'privileged' = 'true') > 0
          THEN 'fail'
          ELSE 'pass'
          END                          AS status
FROM k8s_apps_deployments {% endmacro %}

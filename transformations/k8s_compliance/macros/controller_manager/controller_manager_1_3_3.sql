{% macro controller_manager_1_3_3(framework, check_id) %}
WITH
  pod_containers_commands
    AS (
      SELECT
        uid, container, command
      FROM
        k8s_core_pods,
        jsonb_array_elements(spec_containers) AS container,
        jsonb_array_elements(container->'command') AS command
    )
SELECT
    uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
    'Ensure that the --use-service-account-credentials argument is set to true' AS title,
    context                          AS context,
    namespace                        AS namespace,
    name                             AS resource_name,
  CASE
  WHEN labels->'component' <> '"kube-controller-manager"' THEN 'pass'
  WHEN labels->'component' is null THEN 'pass'
  WHEN (
    SELECT
      count(*)
    FROM
      pod_containers_commands
    WHERE
      pod_containers_commands.uid = k8s_core_pods.uid
      AND split_part(command::text, '=', 1) = '"--use-service-account-credentials' 
      AND split_part(command::text, '=', 2) = 'true"'
  )
  = 0
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods


-- 1.3.4

{% endmacro %}
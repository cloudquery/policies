{% macro controller_manager_1_3_7(framework, check_id) %}
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
    'Ensure that the --bind-address argument is set to 127.0.0.1' AS title,
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
      AND split_part(command::text, '=', 1) = '"--bind-address' 
      AND split_part(command::text, '=', 2) = '127.0.0.1"'
  )
  = 0
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods
{% endmacro %}
{% macro controller_manager_1_3_5(framework, check_id) %}
  {{ return(adapter.dispatch('controller_manager_1_3_5')(framework, check_id)) }}
{% endmacro %}

{% macro default__controller_manager_1_3_5(framework, check_id) %}{% endmacro %}

{% macro postgres__controller_manager_1_3_5(framework, check_id) %}
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
    'Ensure that the --root-ca-file argument is set as appropriate' AS title,
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
      AND split_part(command::text, '=', 1) = '"--root-ca-file' 
      AND split_part(command::text, '=', 2) is not null
  )
  = 0
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods
{% endmacro %}

{% macro snowflake__controller_manager_1_3_5(framework, check_id) %}
WITH
  pod_containers_commands
    AS (
      SELECT
        uid,
        container.value AS container,
        command.value AS command
      FROM
        k8s_core_pods,
       LATERAL FLATTEN(spec_containers) AS container,
       LATERAL FLATTEN(container:command) AS command
    )
SELECT
    uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
    'Ensure that the --root-ca-file argument is set as appropriate' AS title,
    context                          AS context,
    namespace                        AS namespace,
    name                             AS resource_name,
  CASE
  WHEN labels:component <> '"kube-controller-manager"' THEN 'pass'
  WHEN labels:component is null THEN 'pass'
  WHEN (
    SELECT
      count(*)
    FROM
      pod_containers_commands
    WHERE
      pod_containers_commands.uid = k8s_core_pods.uid
      AND split_part(command::text, '=', 1) = '"--root-ca-file' 
      AND split_part(command::text, '=', 2) is not null
  )
  = 0
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods
{% endmacro %}

{% macro bigquery__controller_manager_1_3_5(framework, check_id) %}

{% endmacro %}
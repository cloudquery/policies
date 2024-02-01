{% macro pod_security_standards_5_2_1(framework, check_id) %}
  {{ return(adapter.dispatch('pod_security_standards_5_2_1')(framework, check_id)) }}
{% endmacro %}

{% macro default__pod_security_standards_5_2_1(framework, check_id) %}{% endmacro %}

{% macro postgres__pod_security_standards_5_2_1(framework, check_id) %}
WITH pod_containers
    AS (
      SELECT
        uid, value AS container
      FROM
        k8s_core_pods,
        jsonb_array_elements(spec_containers) AS value
    )
SELECT
    uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
    'Ensure that the cluster has at least one active policy control mechanism in place' AS title,
    context                          AS context,
    namespace                        AS namespace,
    name                             AS resource_name,
  CASE
  WHEN (
    SELECT
      count(*)
    FROM
      pod_containers
    WHERE
      pod_containers.uid = k8s_core_pods.uid
      AND (pod_containers.container->'allowPrivilegeEscalation' = 'false' or pod_containers.container->'allowPrivilegeEscalation' is null)
  )
  < 1
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods
{% endmacro %}

{% macro snowflake__pod_security_standards_5_2_1(framework, check_id) %}
WITH pod_containers
    AS (
      SELECT
        uid, container.value AS container
      FROM
        k8s_core_pods,
      LATERAL FLATTEN(spec_containers) AS container
    )
SELECT
    uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
    'Ensure that the cluster has at least one active policy control mechanism in place' AS title,
    context                          AS context,
    namespace                        AS namespace,
    name                             AS resource_name,
  CASE
  WHEN (
    SELECT
      count(*)
    FROM
      pod_containers
    WHERE
      pod_containers.uid = k8s_core_pods.uid
      AND (pod_containers.container:securityContext:allowPrivilegeEscalation = 'false' or pod_containers.container:securityContext:allowPrivilegeEscalation is null)
  )
  < 1
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods
{% endmacro %}

{% macro bigquery__pod_security_standards_5_2_1(framework, check_id) %}

{% endmacro %}
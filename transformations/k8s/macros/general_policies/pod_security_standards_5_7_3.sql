{% macro pod_security_standards_5_7_3(framework, check_id) %}
  {{ return(adapter.dispatch('pod_security_standards_5_7_3')(framework, check_id)) }}
{% endmacro %}

{% macro default__pod_security_standards_5_7_3(framework, check_id) %}{% endmacro %}

{% macro postgres__pod_security_standards_5_7_3(framework, check_id) %}
WITH
pod_containers
    AS (
      SELECT
        uid, container
      FROM
       k8s_core_pods, 
       jsonb_array_elements(spec_containers) AS container
    )
SELECT
    uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
    'Apply Security Context to Your Pods and Containers' AS title,
    context                          AS context,
    namespace                        AS namespace,
    name                             AS resource_name,
  CASE
  WHEN spec_security_context is null THEN 'fail'
  WHEN (
    SELECT
      count(*)
    FROM
      pod_containers
    WHERE
      pod_containers.uid = k8s_core_pods.uid
      AND 
      container->'securityContext' IS NULL
  )> 0
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods
{% endmacro %}

{% macro snowflake__pod_security_standards_5_7_3(framework, check_id) %}
WITH
pod_containers
    AS (
      SELECT
        uid, container.value as container
      FROM
       k8s_core_pods,
      LATERAL FLATTEN(spec_containers) AS container
    )
SELECT
    uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
    'Apply Security Context to Your Pods and Containers' AS title,
    context                          AS context,
    namespace                        AS namespace,
    name                             AS resource_name,
  CASE
  WHEN spec_security_context is null THEN 'fail'
  WHEN (
    SELECT
      count(*)
    FROM
      pod_containers
    WHERE
      pod_containers.uid = k8s_core_pods.uid
      AND 
      container:securityContext IS NULL
  )> 0
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods
{% endmacro %}

{% macro bigquery__pod_security_standards_5_7_3(framework, check_id) %}

{% endmacro %}
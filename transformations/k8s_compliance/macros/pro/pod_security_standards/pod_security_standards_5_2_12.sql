{% macro pod_security_standards_5_2_12(framework, check_id) %}
WITH
  pod_volumes
    AS (
      SELECT
        uid, value AS volume
      FROM
        k8s_core_pods,
        jsonb_array_elements(spec_volumes) AS value
    )
SELECT
    uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
    'Minimize the admission of HostPath volumes' AS title,
    context                          AS context,
    namespace                        AS namespace,
    name                             AS resource_name,
    CASE
  WHEN spec_volumes is null THEN 'pass'
  WHEN (
    SELECT 
      count(*)
    FROM
      pod_volumes
    WHERE
      pod_volumes.uid = k8s_core_pods.uid
      AND 
      NOT (volume->'hostPath' is null
          OR
          volume->'hostPath'->'path' is null
          OR
          (volume->'hostPath'->'path')::text = ''
          )
  )
  > 0
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods

-- 5.2.13

{% endmacro %}
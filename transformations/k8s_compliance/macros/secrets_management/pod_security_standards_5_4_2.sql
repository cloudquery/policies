{% macro pod_security_standards_5_4_2(framework, check_id) %}WITH
  pod_containers
    AS (
      SELECT
        uid, volume
      FROM
       k8s_core_pods, 
       jsonb_array_elements(spec_volumes) AS volume
    )
SELECT
    uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
    'Consider external secret storage' AS title,
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
      AND volume->'secret' IS NOT NULL
  )> 0
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods
{% endmacro %}
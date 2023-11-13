{% macro pod_security_standards_5_2_9(framework, check_id) %}
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
    'Minimize the admission of containers with added capabilities' AS title,
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
      AND 
       container->'securityContext'->'capabilities'->'add' IS NOT NULL
  AND 
  NOT (container->'securityContext'->'capabilities'->'add' = '[]'::jsonb)
  )
  > 0
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods

-- 5.2.10

{% endmacro %}
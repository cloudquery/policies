{% macro pod_security_standards_5_4_1(framework, check_id) %}WITH
  pod_containers
    AS (
      SELECT
        uid, env_var
      FROM
       k8s_core_pods, 
       jsonb_array_elements(spec_containers) AS container,
       jsonb_array_elements(container->'env') AS env_var
    )
SELECT
    uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
    'Prefer using secrets as files over secrets as environment variables' AS title,
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
      AND env_var->'valueFrom'->'secretKeyRef' IS NOT NULL
  )> 0
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods


-- 5.4.2

{% endmacro %}
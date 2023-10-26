-- 5.4.1
\echo "pod_security_standards_5.4.1"
INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                 resource_name, status)
WITH
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
    :'execution_time'::timestamp     AS execution_time,
    :'framework'                     AS framework,
    'pod_security_standards_5.4.1'                      AS check_id,
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
  k8s_core_pods;


-- 5.4.2
\echo "pod_security_standards_5.4.2"
INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                 resource_name, status)
WITH
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
    :'execution_time'::timestamp     AS execution_time,
    :'framework'                     AS framework,
    'pod_security_standards_5.4.2'                      AS check_id,
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
  k8s_core_pods;
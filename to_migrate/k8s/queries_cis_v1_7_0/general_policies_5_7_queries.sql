-- 5.7.1 - TODO

-- 5.7.2
 \echo "pod_security_standards_5.7.2"
INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                 resource_name, status)
SELECT
    uid                              AS resource_id,
    :'execution_time'::timestamp     AS execution_time,
    :'framework'                     AS framework,
    'pod_security_standards_5.7.2'                      AS check_id,
    'Ensure that the seccomp profile is set to docker/default in your pod definitions' AS title,
    context                          AS context,
    namespace                        AS namespace,
    name                             AS resource_name,
  CASE
  WHEN 
      spec_security_context->'seccompProfile' IS NULL
      OR
      NOT((spec_security_context)::text LIKE '%docker/default%')
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods;

  -- 5.7.3
 \echo "pod_security_standards_5.7.3"
INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                 resource_name, status)
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
    :'execution_time'::timestamp     AS execution_time,
    :'framework'                     AS framework,
    'pod_security_standards_5.7.3'                      AS check_id,
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
  k8s_core_pods;

  -- 5.7.4
 \echo "pod_security_standards_5.7.4"
INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                 resource_name, status)
-- only pods, talk with jason for more ressoures
SELECT
    uid                              AS resource_id,
    :'execution_time'::timestamp     AS execution_time,
    :'framework'                     AS framework,
    'pod_security_standards_5.7.4'                      AS check_id,
    'The default namespace should not be used' AS title,
    context                          AS context,
    namespace                        AS namespace,
    name                             AS resource_name,
  CASE
  WHEN namespace = 'default'
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods;
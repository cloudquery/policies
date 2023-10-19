-- 5.2.1 TODO
-- 5.2.2
 \echo "pod_security_standards_5.2.2"

 INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                 resource_name, status)
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
    :'execution_time'::timestamp     AS execution_time,
    :'framework'                     AS framework,
    'pod_security_standards_5.2.2'                      AS check_id,
    'Minimize the admission of privileged containers' AS title,
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
      AND pod_containers.container->'securityContext'->>'privileged' = 'true'
  )
  > 0
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods;

-- 5.2.3
 \echo "pod_security_standards_5.2.3"

 INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                 resource_name, status)
SELECT
    uid                              AS resource_id,
    :'execution_time'::timestamp     AS execution_time,
    :'framework'                     AS framework,
    'pod_security_standards_5.2.3'                      AS check_id,
    'Minimize the admission of containers wishing to share the host process ID namespace' AS title,
    context                          AS context,
    namespace                        AS namespace,
    name                             AS resource_name,
  CASE
  WHEN spec_host_pid THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods;

-- 5.2.4
 \echo "pod_security_standards_5.2.4"

 INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                 resource_name, status)
SELECT
    uid                              AS resource_id,
    :'execution_time'::timestamp     AS execution_time,
    :'framework'                     AS framework,
    'pod_security_standards_5.2.4'                      AS check_id,
    'Minimize the admission of containers wishing to share the host IPC namespace' AS title,
    context                          AS context,
    namespace                        AS namespace,
    name                             AS resource_name,
  CASE
  WHEN spec_host_ipc THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods;

-- 5.2.5
 \echo "pod_security_standards_5.2.5"

 INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                 resource_name, status)
SELECT
    uid                              AS resource_id,
    :'execution_time'::timestamp     AS execution_time,
    :'framework'                     AS framework,
    'pod_security_standards_5.2.5'                      AS check_id,
    'Minimize the admission of containers wishing to share the host network namespace' AS title,
    context                          AS context,
    namespace                        AS namespace,
    name                             AS resource_name,
  CASE
  WHEN spec_host_network THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods;

-- 5.2.6
 \echo "pod_security_standards_5.2.6"

 INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                 resource_name, status)
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
    :'execution_time'::timestamp     AS execution_time,
    :'framework'                     AS framework,
    'pod_security_standards_5.2.6'                      AS check_id,
    'Minimize the admission of privileged containers' AS title,
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
      AND pod_containers.container->'securityContext'->>'allowPrivilegeEscalation' = 'true'
  )
  > 0
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods;
  
-- 5.2.7 TODO

-- 5.2.8
 \echo "pod_security_standards_5.2.8"

 INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                 resource_name, status)
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
    :'execution_time'::timestamp     AS execution_time,
    :'framework'                     AS framework,
    'pod_security_standards_5.2.8'                      AS check_id,
    'Minimize the admission of containers with the NET_RAW capability' AS title,
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
      (pod_containers.container->'securityContext'->'capabilities'->'add' ? 'NET_RAW'
      OR
      pod_containers.container->'securityContext'->'capabilities'->'add' ? 'ALL'
      OR
      pod_containers.container->'securityContext'->'capabilities'->'add' ? 'all')
  )
  > 0
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods;

-- 5.2.9
 \echo "pod_security_standards_5.2.9"

 INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                 resource_name, status)
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
    :'execution_time'::timestamp     AS execution_time,
    :'framework'                     AS framework,
    'pod_security_standards_5.2.9'                      AS check_id,
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
  k8s_core_pods;

-- 5.2.10
 \echo "pod_security_standards_5.2.10"

 INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                 resource_name, status)
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
    :'execution_time'::timestamp     AS execution_time,
    :'framework'                     AS framework,
    'pod_security_standards_5.2.10'                      AS check_id,
    'Minimize the admission of containers with capabilities assigned' AS title,
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
  NOT (container->'securityContext'->'capabilities'->'drop' ? 'all'
      OR
      container->'securityContext'->'capabilities'->'drop' ? 'ALL')
  )
  > 0
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods;

-- 5.2.11
 \echo "pod_security_standards_5.2.11"

 INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                 resource_name, status)
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
    :'execution_time'::timestamp     AS execution_time,
    :'framework'                     AS framework,
    'pod_security_standards_5.2.11'                      AS check_id,
    'Minimize the admission of Windows HostProcess Containers' AS title,
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
      container->'securityContext'->'windowsOptions'->'hostProcess' = 'true' 
  )
  > 0
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods;

-- 5.2.12
 \echo "pod_security_standards_5.2.12"

 INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                 resource_name, status)
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
    :'execution_time'::timestamp     AS execution_time,
    :'framework'                     AS framework,
    'pod_security_standards_5.2.12'                      AS check_id,
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
  k8s_core_pods;

-- 5.2.13
 \echo "pod_security_standards_5.2.13"

 INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                 resource_name, status)
WITH
  containers
    AS (
      SELECT
        uid, c_ports->'hostPort' as hostPort
      FROM
        k8s_core_pods,
        jsonb_array_elements(spec_containers) AS value,
        jsonb_array_elements(value->'ports') as c_ports
    ),
  init_containers AS (
  SELECT
        uid, c_ports->'hostPort' as hostPort
      FROM
        k8s_core_pods,
        jsonb_array_elements(spec_init_containers) AS value,
        jsonb_array_elements(value->'ports') as c_ports

  ),
  ephemeral_containers AS (
  SELECT
        uid, c_ports->'hostPort' as hostPort
      FROM
        k8s_core_pods,
        jsonb_array_elements(spec_ephemeral_containers) AS value,
        jsonb_array_elements(value->'ports') as c_ports
  )

SELECT
  uid                              AS resource_id,
    :'execution_time'::timestamp     AS execution_time,
    :'framework'                     AS framework,
    'pod_security_standards_5.2.13'                      AS check_id,
    'Minimize the admission of containers which use HostPorts' AS title,
    context                          AS context,
    namespace                        AS namespace,
    name                             AS resource_name,
  CASE
  WHEN (
    SELECT
      count(*)
    FROM
      containers
    WHERE
      containers.uid = k8s_core_pods.uid
      AND 
      hostPort is not null
  )
  > 0
  THEN 'fail'
  WHEN (
    SELECT
      count(*)
    FROM
      init_containers
    WHERE
      init_containers.uid = k8s_core_pods.uid
      AND 
      hostPort is not null
  )
  > 0
  THEN 'fail'
  WHEN (
    SELECT
      count(*)
    FROM
      ephemeral_containers
    WHERE
      ephemeral_containers.uid = k8s_core_pods.uid
      AND 
      hostPort is not null
  )
  > 0
  THEN 'fail'
  
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods;
-- 1.3.1
 \echo "controller_manager_1.3.1"

 INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                 resource_name, status)
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
    :'execution_time'::timestamp     AS execution_time,
    :'framework'                     AS framework,
    'controller_manager_1.3.1'                      AS check_id,
    'Ensure that the --terminated-pod-gc-threshold argument is set as appropriate' AS title,
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
      AND split_part(command::text, '=', 1) = '"--terminated-pod-gc-threshold' 
      AND split_part(command::text, '=', 2) is not null
  )
  = 0
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods;

-- 1.3.2
\echo "controller_manager_1.3.2"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                 resource_name, status)
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
    :'execution_time'::timestamp     AS execution_time,
    :'framework'                     AS framework,
    'controller_manager_1.3.2'                      AS check_id,
    'Ensure that the --profiling argument is set to false' AS title,
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
      AND split_part(command::text, '=', 1) = '"--profiling' 
      AND split_part(command::text, '=', 2) = 'false"'
  )
  = 0
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods;

-- 1.3.3
\echo "controller_manager_1.3.3"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                 resource_name, status)
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
    :'execution_time'::timestamp     AS execution_time,
    :'framework'                     AS framework,
    'controller_manager_1.3.3'                      AS check_id,
    'Ensure that the --use-service-account-credentials argument is set to true' AS title,
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
      AND split_part(command::text, '=', 1) = '"--use-service-account-credentials' 
      AND split_part(command::text, '=', 2) = 'true"'
  )
  = 0
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods;


-- 1.3.4
\echo "controller_manager_1.3.4"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                 resource_name, status)
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
    :'execution_time'::timestamp     AS execution_time,
    :'framework'                     AS framework,
    'controller_manager_1.3.4'                      AS check_id,
    'Ensure that the --service-account-private-key-file argument is set as appropriate' AS title,
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
      AND split_part(command::text, '=', 1) = '"--service-account-private-key-file'
      AND split_part(command::text, '=', 2) is not null
  )
  = 0
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods;

-- 1.3.5
\echo "controller_manager_1.3.5"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                 resource_name, status)
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
    :'execution_time'::timestamp     AS execution_time,
    :'framework'                     AS framework,
    'controller_manager_1.3.5'                      AS check_id,
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
  k8s_core_pods;

-- 1.3.6
\echo "controller_manager_1.3.6"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                 resource_name, status)
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
    :'execution_time'::timestamp     AS execution_time,
    :'framework'                     AS framework,
    'controller_manager_1.3.6'                      AS check_id,
    'Ensure that the RotateKubeletServerCertificate argument is set to true' AS title,
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
      AND command::text LIKE '%%RotateKubeletServerCertificate=true%%'
  )
  = 0
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods;


-- 1.3.7
\echo "controller_manager_1.3.7"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                 resource_name, status)
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
    :'execution_time'::timestamp     AS execution_time,
    :'framework'                     AS framework,
    'controller_manager_1.3.7'                      AS check_id,
    'Ensure that the --bind-address argument is set to 127.0.0.1' AS title,
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
      AND split_part(command::text, '=', 1) = '"--bind-address' 
      AND split_part(command::text, '=', 2) = '127.0.0.1"'
  )
  = 0
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods;
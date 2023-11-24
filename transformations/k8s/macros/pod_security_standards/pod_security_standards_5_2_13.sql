{% macro pod_security_standards_5_2_13(framework, check_id) %}
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
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
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
  k8s_core_pods
{% endmacro %}
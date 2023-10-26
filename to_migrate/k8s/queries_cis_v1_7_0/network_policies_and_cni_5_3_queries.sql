-- 5.3.2
\echo "pod_security_standards_5.3.2"

 INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                 resource_name, status)
SELECT 
    uid                              AS resource_id,
    :'execution_time'::timestamp     AS execution_time,
    :'framework'                     AS framework,
    'pod_security_standards_5.3.2'                      AS check_id,
    'Ensure that all Namespaces have Network Policies defined' AS title,
    context                          AS context,
    namespace                        AS namespace,
    name                             AS resource_name,
    CASE
        WHEN (
        SELECT
          count(*)
        FROM
          k8s_networking_network_policies np
        WHERE
          np.namespace = n.name
      )
      = 0
      THEN 'fail'
      ELSE 'pass'
    END as status
FROM 
    k8s_core_namespaces n
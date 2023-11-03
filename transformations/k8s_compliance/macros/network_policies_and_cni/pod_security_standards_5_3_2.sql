{% macro pod_security_standards_5_3_2(framework, check_id) %}
SELECT 
    uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
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
{% endmacro %}
{% macro pod_security_standards_5_2_4(framework, check_id) %}
SELECT
    uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
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
  k8s_core_pods

-- 5.2.5

{% endmacro %}
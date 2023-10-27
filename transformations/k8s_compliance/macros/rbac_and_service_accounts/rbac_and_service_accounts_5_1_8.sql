{% macro rbac_and_service_accounts_5_1_8(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
        'Limit use of the Bind, Impersonate and Escalate permissions in the Kubernetes cluster' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
        case when
          rule -> 'verbs' ?| array['bind', 'impersonate', 'escalate']
          then 'fail'
          else 'pass'
        end as status
from
  k8s_rbac_cluster_roles,
  jsonb_array_elements(rules) rule


{% endmacro %}
{% macro rbac_and_service_accounts_5_1_7(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
        'Avoid use of system:masters group' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
        case
          when sub ->> 'name' like 'system:masters'
          then 'fail'
          else 'pass'
        end as status
from
  k8s_rbac_cluster_role_bindings,
  jsonb_array_elements(subjects) sub


{% endmacro %}
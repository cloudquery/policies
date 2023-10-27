{% macro rbac_and_service_accounts_5_1_2(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
        'Minimize access to secrets' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
        case
            when rule -> 'resources' ? 'secrets' and rule -> 'verbs'  ?| array['get', 'list'] then 'fail'
            when rule -> 'resources' ? 'secrets' and rule -> 'verbs'  ?| array['watch'] then 'fail'
            else 'pass'
        end as status
from
  k8s_rbac_cluster_roles,
  jsonb_array_elements(rules) rule
where
  name not like '%system%'


{% endmacro %}
{% macro rbac_and_service_accounts_5_1_8(framework, check_id) %}
  {{ return(adapter.dispatch('rbac_and_service_accounts_5_1_8')(framework, check_id)) }}
{% endmacro %}

{% macro default__rbac_and_service_accounts_5_1_8(framework, check_id) %}{% endmacro %}

{% macro postgres__rbac_and_service_accounts_5_1_8(framework, check_id) %}
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

{% macro snowflake__rbac_and_service_accounts_5_1_8(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
        'Limit use of the Bind, Impersonate and Escalate permissions in the Kubernetes cluster' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
        case when
        (
        ARRAY_CONTAINS('bind'::variant, rule.value:verbs)
        or 
        ARRAY_CONTAINS('impersonate'::variant, rule.value:resources)
        or
        ARRAY_CONTAINS('escalate'::variant, rule.value:resources)
        )
          then 'fail'
          else 'pass'
        end as status
from
  k8s_rbac_cluster_roles,
  LATERAL FLATTEN(rules) AS rule
{% endmacro %}

{% macro bigquery__rbac_and_service_accounts_5_1_8(framework, check_id) %}

{% endmacro %}
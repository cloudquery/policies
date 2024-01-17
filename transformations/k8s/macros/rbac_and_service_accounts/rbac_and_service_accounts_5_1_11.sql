{% macro rbac_and_service_accounts_5_1_11(framework, check_id) %}
  {{ return(adapter.dispatch('rbac_and_service_accounts_5_1_11')(framework, check_id)) }}
{% endmacro %}

{% macro default__rbac_and_service_accounts_5_1_11(framework, check_id) %}{% endmacro %}

{% macro postgres__rbac_and_service_accounts_5_1_11(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
        'Minimize access to the approval sub-resource of certificatesigningrequests objects' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
       	case
          when 
            rule -> 'resources' ? 'certificatesigningrequests/approval' and rule ->'verbs' ?| array['update', '*']
          then 'fail'
          else 'pass'
        end as status
from
  k8s_rbac_cluster_roles,
  jsonb_array_elements(rules) rule
{% endmacro %}

{% macro snowflake__rbac_and_service_accounts_5_1_11(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
        'Minimize access to the approval sub-resource of certificatesigningrequests objects' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
       	case
          when
          ARRAY_CONTAINS('certificatesigningrequests/approval'::variant, rule.value:resources)
          and
          (
          ARRAY_CONTAINS('update'::variant, rule.value:verbs)
            or
          ARRAY_CONTAINS('*'::variant, rule.value:verbs)
          )
          then 'fail'
          else 'pass'
        end as status
from
  k8s_rbac_cluster_roles,
  LATERAL FLATTEN(rules) AS rule
{% endmacro %}

{% macro bigquery__rbac_and_service_accounts_5_1_11(framework, check_id) %}

{% endmacro %}
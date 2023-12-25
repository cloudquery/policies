{% macro rbac_and_service_accounts_5_1_4(framework, check_id) %}
  {{ return(adapter.dispatch('rbac_and_service_accounts_5_1_4')(framework, check_id)) }}
{% endmacro %}

{% macro default__rbac_and_service_accounts_5_1_4(framework, check_id) %}{% endmacro %}

{% macro postgres__rbac_and_service_accounts_5_1_4(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
        'Minimize access to create pods' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
        case
          when 
          rule -> 'resources' ? 'pod' and rule ->'verbs' ? 'create'
          then 'fail'
          else 'pass'
        end as status
from
  k8s_rbac_cluster_roles,
  jsonb_array_elements(rules) rule
where
  name not like '%system%'
{% endmacro %}

{% macro snowflake__rbac_and_service_accounts_5_1_4(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
        'Minimize access to create pods' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
        case
          when
          ARRAY_CONTAINS('pod'::variant, rule.value:resources)
          and 
          ARRAY_CONTAINS('create'::variant, rule.value:verbs)
          then 'fail'
          else 'pass'
        end as status
from
  k8s_rbac_cluster_roles,
  LATERAL FLATTEN(rules) AS rule
where
  name not like '%system%'
{% endmacro %}

{% macro bigquery__rbac_and_service_accounts_5_1_4(framework, check_id) %}

{% endmacro %}
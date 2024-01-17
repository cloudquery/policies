{% macro rbac_and_service_accounts_5_1_6(framework, check_id) %}
  {{ return(adapter.dispatch('rbac_and_service_accounts_5_1_6')(framework, check_id)) }}
{% endmacro %}

{% macro default__rbac_and_service_accounts_5_1_6(framework, check_id) %}{% endmacro %}

{% macro postgres__rbac_and_service_accounts_5_1_6(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
        'Ensure that Service Account Tokens are only mounted where necessary' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
        case
          when
          automount_service_account_token = true
          then 'fail'
          else 'pass'
        end as status
FROM
  k8s_core_service_accounts
{% endmacro %}

{% macro snowflake__rbac_and_service_accounts_5_1_6(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
        'Ensure that Service Account Tokens are only mounted where necessary' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
        case
          when
          automount_service_account_token = true
          then 'fail'
          else 'pass'
        end as status
FROM
  k8s_core_service_accounts
{% endmacro %}

{% macro bigquery__rbac_and_service_accounts_5_1_6(framework, check_id) %}

{% endmacro %}
{% macro service_account_token_disabled(framework, check_id) %}
  {{ return(adapter.dispatch('service_account_token_disabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__service_account_token_disabled(framework, check_id) %}{% endmacro %}

{% macro postgres__service_account_token_disabled(framework, check_id) %}
                               resource_name, status)
select DISTINCT uid                                    AS resource_id,
                '{{framework}}'                           AS framework,
                '{{check_id}}'                            AS check_id,
                'Pod service account tokens disabled' AS title,
                context                                AS context,
                namespace                              AS namespace,
                name                                   AS resource_name,
                CASE
                    WHEN
                        automount_service_account_token
                        THEN 'fail'
                    ELSE 'pass'
                    END                                AS status
FROM k8s_core_service_accounts
{% endmacro %}

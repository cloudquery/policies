{% macro pod_service_account_token_disabled(framework, check_id) %}
  {{ return(adapter.dispatch('pod_service_account_token_disabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__pod_service_account_token_disabled(framework, check_id) %}{% endmacro %}

{% macro postgres__pod_service_account_token_disabled(framework, check_id) %}
select DISTINCT uid                                   AS resource_id,
                '{{framework}}'                          AS framework,
                '{{check_id}}'                           AS check_id,
                'Pod service account tokens disabled' AS title,
                context                               AS context,
                namespace                             AS namespace,
                name                                  AS resource_name,
                CASE
                    WHEN
                        spec_automount_service_account_token
                        THEN 'fail'
                    ELSE 'pass'
                    END                               AS status
FROM k8s_core_pods
{% endmacro %}

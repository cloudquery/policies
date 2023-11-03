{% macro namespace_resource_quota_memory_limit(framework, check_id) %}
  {{ return(adapter.dispatch('namespace_resource_quota_memory_limit')(framework, check_id)) }}
{% endmacro %}

{% macro default__namespace_resource_quota_memory_limit(framework, check_id) %}{% endmacro %}

{% macro postgres__namespace_resource_quota_memory_limit(framework, check_id) %}
select DISTINCT (k8s_core_namespaces.uid)                         AS resource_id,
                '{{framework}}'                                      AS framework,
                '{{check_id}}'                                       AS check_id,
                'Namespace enforces resource quota memory limits' AS title,
                k8s_core_namespaces.context                       AS context,
                k8s_core_namespaces.name                          AS namespace,
                k8s_core_namespaces.name                          AS resource_name,
                CASE
                    WHEN
                        (SELECT COUNT(*) FROM k8s_core_resource_quotas 
                            WHERE namespace = k8s_core_namespaces.name
                            AND context = k8s_core_namespaces.context
                            AND spec_hard->>'limits.memory' IS NOT NULL) = 0 
                        THEN 'fail'
                    ELSE 'pass'
                    END                                           AS status
FROM k8s_core_namespaces{% endmacro %}

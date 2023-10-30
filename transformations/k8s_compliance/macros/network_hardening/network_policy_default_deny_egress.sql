{% macro network_policy_default_deny_egress(framework, check_id) %}
  {{ return(adapter.dispatch('network_policy_default_deny_egress')(framework, check_id)) }}
{% endmacro %}

{% macro default__network_policy_default_deny_egress(framework, check_id) %}{% endmacro %}

{% macro postgres__network_policy_default_deny_egress(framework, check_id) %}
INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                        resource_name, status)
select uid                                   AS resource_id,
       '{{framework}}'                         AS framework,
       '{{check_id}}'                          AS check_id,
       'Network policy default deny egress' AS title,
       context                              AS context,
       name                                 AS namespace,
       name                                 AS resource_name,
       CASE
         WHEN
            (SELECT COUNT(*) FROM k8s_networking_network_policies 
               WHERE namespace = k8s_core_namespaces.name
               AND context = k8s_core_namespaces.context
               AND spec_policy_types @> ARRAY['Egress']
               AND spec_pod_selector::TEXT = '{}'
               AND ((spec_egress IS NULL) OR (JSONB_ARRAY_LENGTH(spec_egress) = 0))) = 0
            THEN 'fail'
         ELSE 'pass'
         END                                AS STATUS

FROM k8s_core_namespaces{% endmacro %}

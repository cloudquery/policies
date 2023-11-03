{% macro namespace_limit_range_default_cpu_request(framework, check_id) %}
  {{ return(adapter.dispatch('namespace_limit_range_default_cpu_request')(framework, check_id)) }}
{% endmacro %}

{% macro default__namespace_limit_range_default_cpu_request(framework, check_id) %}{% endmacro %}

{% macro postgres__namespace_limit_range_default_cpu_request(framework, check_id) %}
WITH default_request_cpu_limits AS (
   SELECT context, namespace, value->'default_request'->>'cpu' AS default_request_cpu_limit
   FROM k8s_core_limit_ranges CROSS JOIN jsonb_array_elements(k8s_core_limit_ranges.spec_limits))

select uid                                         AS resource_id,
       '{{framework}}'                                AS framework,
       '{{check_id}}'                                 AS check_id,
       'Namespaces CPU request resource quota' AS title,
       context                                     AS context,
       name                                        AS namespace,
       name                                        AS resource_name,
       CASE
           WHEN
               (SELECT COUNT(default_request_cpu_limit) FROM default_request_cpu_limits 
                  WHERE namespace = k8s_core_namespaces.name
                  AND context = k8s_core_namespaces.context) = 0
               THEN 'fail'
           ELSE 'pass'
           END                                     AS status
FROM k8s_core_namespaces{% endmacro %}

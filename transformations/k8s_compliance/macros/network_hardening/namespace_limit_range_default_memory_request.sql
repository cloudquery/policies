{% macro namespace_limit_range_default_memory_request(framework, check_id) %}
  {{ return(adapter.dispatch('namespace_limit_range_default_memory_request')(framework, check_id)) }}
{% endmacro %}

{% macro default__namespace_limit_range_default_memory_request(framework, check_id) %}{% endmacro %}

{% macro postgres__namespace_limit_range_default_memory_request(framework, check_id) %}


WITH default_request_memory_limits AS (
   SELECT namespace, value->'default_request'->>'memory' AS default_request_memory_limit
   FROM k8s_core_limit_ranges CROSS JOIN jsonb_array_elements(k8s_core_limit_ranges.spec_limits))

select uid                                         AS resource_id,
       '{{framework}}'                                AS framework,
       '{{check_id}}'                                 AS check_id,
       'Namespaces Memory request resource quota' AS title,
       context                                     AS context,
       name                                        AS namespace,
       name                                        AS resource_name,
       CASE
           WHEN
               (SELECT COUNT(default_request_memory_limit) FROM default_request_memory_limits  
                  WHERE namespace = k8s_core_namespaces.name
                  AND context = k8s_core_namespaces.context) = 0
               THEN 'fail'
           ELSE 'pass'
           END                                     AS status
FROM k8s_core_namespaces {% endmacro %}

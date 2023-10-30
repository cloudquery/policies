{% macro replicaset_memory_limit(framework, check_id) %}
  {{ return(adapter.dispatch('replicaset_memory_limit')(framework, check_id)) }}
{% endmacro %}

{% macro default__replicaset_memory_limit(framework, check_id) %}{% endmacro %}

{% macro postgres__replicaset_memory_limit(framework, check_id) %}
-- Join every row in the replica_set table with its json array of containers.
WITH replica_set_containers AS (SELECT uid, value AS container 
                               FROM k8s_apps_replica_sets
                               CROSS JOIN jsonb_array_elements(spec_template->'spec'->'containers') AS value)

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        '{{framework}}'                     AS framework,
        '{{check_id}}'                      AS check_id,
        'Replicaset enforces memory limits' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
        CASE
            WHEN
                  -- Every container needs to have a memory limit for the check to pass
                  (SELECT COUNT(*) FROM replica_set_containers WHERE replica_set_containers.uid = k8s_apps_replica_sets.uid AND
                  replica_set_containers.container->'resources'->'limits'->>'memory' IS NULL) > 0
                THEN 'fail'
                ELSE 'pass'
            END                          AS status
FROM k8s_apps_replica_sets{% endmacro %}

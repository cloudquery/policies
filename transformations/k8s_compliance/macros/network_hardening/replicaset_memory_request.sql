{% macro replicaset_memory_request(framework, check_id) %}
  {{ return(adapter.dispatch('replicaset_memory_request')(framework, check_id)) }}
{% endmacro %}

{% macro default__replicaset_memory_request(framework, check_id) %}{% endmacro %}

{% macro postgres__replicaset_memory_request(framework, check_id) %}
-- Join every row in the deployment table with its json array of containers.
With replica_set_containers AS (SELECT uid, value AS container 
                               FROM k8s_apps_replica_sets
                               CROSS JOIN jsonb_array_elements(spec_template->'spec'->'containers') AS value)

                                resource_name, status)
select uid                              AS resource_id,
        '{{framework}}'                     AS framework,
        '{{check_id}}'                      AS check_id,
        'Replicaset enforces memory requests' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
        CASE
            WHEN
                  -- Every container needs to have a memory request for the check to pass
                  (SELECT COUNT(*) FROM replica_set_containers WHERE replica_set_containers.uid = k8s_apps_replica_sets.uid AND
                  replica_set_containers.container->'resources'->'requests'->>'memory' IS NULL) > 0
                THEN 'fail'
                ELSE 'pass'
            END                          AS status
FROM k8s_apps_replica_sets{% endmacro %}

{% macro replicaset_immutable_container_filesystem(framework, check_id) %}
  {{ return(adapter.dispatch('replicaset_immutable_container_filesystem')(framework, check_id)) }}
{% endmacro %}

{% macro default__replicaset_immutable_container_filesystem(framework, check_id) %}{% endmacro %}

{% macro postgres__replicaset_immutable_container_filesystem(framework, check_id) %}
WITH replica_set_containers AS (SELECT uid, value AS container 
                               FROM k8s_apps_replica_sets
                               CROSS JOIN jsonb_array_elements(spec_template->'spec'->'containers') AS value)

                                resource_name, status)
select uid                              AS resource_id,
       '{{framework}}'                                          AS framework,
       '{{check_id}}'                                           AS check_id,
       'ReplicaSet containers root file system is read-only' AS title,
       context                                               AS context,
       namespace                                             AS namespace,
       name                                                  AS resource_name,
       CASE
           WHEN
               (SELECT COUNT(*) FROM replica_set_containers WHERE replica_set_containers.uid = k8s_apps_replica_sets.uid AND
                replica_set_containers.container->'securityContext' ->> 'readOnlyRootFilesystem' IS DISTINCT FROM 'true') > 0
               THEN 'fail'
           ELSE 'pass'
           END                                               AS status
FROM k8s_apps_replica_sets;{% endmacro %}

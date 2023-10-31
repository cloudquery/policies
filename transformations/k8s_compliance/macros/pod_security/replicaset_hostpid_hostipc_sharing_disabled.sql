{% macro replicaset_hostpid_hostipc_sharing_disabled(framework, check_id) %}
  {{ return(adapter.dispatch('replicaset_hostpid_hostipc_sharing_disabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__replicaset_hostpid_hostipc_sharing_disabled(framework, check_id) %}{% endmacro %}

{% macro postgres__replicaset_hostpid_hostipc_sharing_disabled(framework, check_id) %}
                               resource_name, status)
select uid                                                           AS resource_id,
       '{{framework}}'                                                  AS framework,
       '{{check_id}}'                                                   AS check_id,
       'ReplicaSet containers HostPID and HostIPC sharing disabled' AS title,
       context                                                       AS context,
       namespace                                                     AS namespace,
       name                                                          AS resource_name,
       CASE
           WHEN
                               spec_template -> 'spec' ->> 'hostPID' = 'true'
                   OR spec_template -> 'spec' ->> 'hostIPC' = 'true'
               THEN 'fail'
           ELSE 'pass'
           END                                                       AS status
FROM k8s_apps_replica_sets;{% endmacro %}

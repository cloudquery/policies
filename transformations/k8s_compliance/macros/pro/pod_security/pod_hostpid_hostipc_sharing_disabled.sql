{% macro pod_hostpid_hostipc_sharing_disabled(framework, check_id) %}
  {{ return(adapter.dispatch('pod_hostpid_hostipc_sharing_disabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__pod_hostpid_hostipc_sharing_disabled(framework, check_id) %}{% endmacro %}

{% macro postgres__pod_hostpid_hostipc_sharing_disabled(framework, check_id) %}
select uid                                                   AS resource_id,
       '{{framework}}'                                          AS framework,
       '{{check_id}}'                                           AS check_id,
       'Pod containers HostPID and HostIPC sharing disabled' AS title,
       context                                               AS context,
       namespace                                             AS namespace,
       name                                                  AS resource_name,
       CASE
           WHEN
               spec_host_pid OR spec_host_ipc
               THEN 'fail'
           ELSE 'pass'
           END                                               AS status
FROM k8s_core_pods{% endmacro %}

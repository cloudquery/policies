{% macro job_hostpid_hostipc_sharing_disabled(framework, check_id) %}
  {{ return(adapter.dispatch('job_hostpid_hostipc_sharing_disabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__job_hostpid_hostipc_sharing_disabled(framework, check_id) %}{% endmacro %}

{% macro postgres__job_hostpid_hostipc_sharing_disabled(framework, check_id) %}
INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                               resource_name, status)
select uid                                                   AS resource_id,
       '{{framework}}'                                          AS framework,
       '{{check_id}}'                                           AS check_id,
       'Job containers HostPID and HostIPC sharing disabled' AS title,
       context                                               AS context,
       namespace                                             AS namespace,
       name                                                  AS resource_name,
       CASE
           WHEN
                               spec_template -> 'spec' ->> 'hostPID' = 'true'
                   OR spec_template -> 'spec' ->> 'hostIPC' = 'true'
               THEN 'fail'
           ELSE 'pass'
           END                                               AS status
FROM k8s_batch_jobs;{% endmacro %}

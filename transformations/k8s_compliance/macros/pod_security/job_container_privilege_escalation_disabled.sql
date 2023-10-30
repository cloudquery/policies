{% macro job_container_privilege_escalation_disabled(framework, check_id) %}
  {{ return(adapter.dispatch('job_container_privilege_escalation_disabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__job_container_privilege_escalation_disabled(framework, check_id) %}{% endmacro %}

{% macro postgres__job_container_privilege_escalation_disabled(framework, check_id) %}
WITH job_containers AS (SELECT uid, value AS container 
                        FROM k8s_batch_jobs
                        CROSS JOIN jsonb_array_elements(spec_template->'spec'->'containers') AS value)

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                                         AS resource_id,
        '{{framework}}'                         AS framework,
        '{{check_id}}'                          AS check_id,
        'Job containers privilege escalation disabled' AS title,
        context                              AS context,
        namespace                            AS namespace,
        name                                 AS resource_name,
        CASE
            WHEN
                (SELECT COUNT(*) FROM job_containers WHERE job_containers.uid = k8s_batch_jobs.uid AND
                job_containers.container->'securityContext'->>'allowPrivilegeEscalation' = 'true') > 0
                THEN 'fail'
            ELSE 'pass'
            END                              AS status
FROM k8s_batch_jobs{% endmacro %}

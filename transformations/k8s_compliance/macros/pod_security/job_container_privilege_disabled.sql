{% macro job_container_privilege_disabled(framework, check_id) %}
  {{ return(adapter.dispatch('job_container_privilege_disabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__job_container_privilege_disabled(framework, check_id) %}{% endmacro %}

{% macro postgres__job_container_privilege_disabled(framework, check_id) %}
WITH job_containers AS (SELECT uid, value AS container 
                        FROM k8s_batch_jobs
                        CROSS JOIN jsonb_array_elements(spec_template->'spec'->'containers') AS value)

select uid                                         AS resource_id,
       '{{framework}}'                         AS framework,
       '{{check_id}}'                          AS check_id,
       'Job containers privileges disabled' AS title,
       context                              AS context,
       namespace                            AS namespace,
       name                                 AS resource_name,
       CASE
           WHEN
               (SELECT COUNT(*) FROM job_containers WHERE job_containers.uid = k8s_batch_jobs.uid AND
              job_containers.container->'securityContext'->>'privileged' = 'true') > 0
               THEN 'fail'
           ELSE 'pass'
           END                              AS status
FROM k8s_batch_jobs

{% endmacro %}
